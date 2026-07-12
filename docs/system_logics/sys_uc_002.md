# System Logic: SYS-UC-002 Enkripsi Barcode, Validasi HMAC & Kalkulasi terlambatmenit

Document Version: v2.0

Use Case ID: SYS-UC-002

Use Case Name: Logika Enkripsi Barcode, Validasi HMAC & Kalkulasi `terlambatmenit`

Status: Draft

Last Updated: 2026-07-12

Author: System Analyst AI

User Flow Terkait: `userflow_uc_002.md`

---

## 1. Overview

Dokumen ini mendefinisikan logika sistem untuk siklus pemindaian barcode dinamis siswa oleh Guru Mapel: validasi Geofence sebelum kamera aktif, dekripsi & verifikasi tanda tangan payload, hardware-binding matching, serta kalkulasi variabel `terlambatmenit` yang menjadi dasar status kehadiran (Hadir/Terlambat) dan pemicu SYS-UC-003 (Liveness Detection).

---

## 2. Sequence Diagram

```mermaid
sequenceDiagram
    actor Guru
    participant AppGuru as App Guru (Mobile)
    actor Siswa
    participant AppSiswa as App Siswa (Mobile)
    participant Gateway as API Gateway
    participant DB as Database

    Guru->>AppGuru: Buka tab "Payroll Schedule", pilih jam pelajaran aktif
    AppGuru->>Gateway: GET geofence-check (koordinat GPS Guru)
    Gateway->>Gateway: Validasi radius ≤ 100 meter dari titik sekolah

    alt Di luar radius Geofence
        Gateway-->>AppGuru: 403 Forbidden - geofence
        AppGuru-->>Guru: Blokir akses kamera + log info blokir
    else Dalam radius Geofence
        Gateway-->>AppGuru: 200 OK
        AppGuru-->>Guru: Aktifkan kamera belakang native

        Siswa->>AppSiswa: Buka halaman Barcode Dinamis
        AppSiswa->>AppSiswa: Generate Payload_Encrypted = AES_256_CBC(Epoch, DeviceID, GeoHash)
        AppSiswa-->>Siswa: Render barcode (refresh tiap 30 detik)

        Guru->>AppGuru: Arahkan kamera ke barcode siswa
        AppGuru->>Gateway: POST /api/v1/scan/validate (payload_scanned, gps_guru)

        alt Jaringan sekolah offline
            AppGuru->>AppGuru: Simpan payload di Offline Standby Buffer (terenkripsi)
            AppGuru-->>Guru: Badge abu-abu "Offline Mode"
            Note over AppGuru,Gateway: Sinkron otomatis pasca-koneksi pulih (SRS-NFR-004)
        else Jaringan normal
            Gateway->>Gateway: Dekripsi payload (AES-256-CBC)
            Gateway->>Gateway: Verifikasi Signature_HMAC = HMAC_SHA256(payload, K_Private_Secret)

            alt Signature tidak valid
                Gateway-->>AppGuru: 401 Unauthorized - invalid signature
                AppGuru-->>Guru: Tolak, indikasi manipulasi/spoofing
            else Signature valid
                Gateway->>DB: Cocokkan DeviceID_Siswa vs Hardware Binding terdaftar

                alt DeviceID tidak cocok
                    Gateway-->>AppGuru: 401 Unauthorized - device mismatch
                    AppGuru-->>Guru: Tolak scan
                else DeviceID cocok
                    Gateway->>DB: Ambil jam_mulai_pelajaran master
                    Gateway->>Gateway: terlambatmenit = waktu_scan_sukses - jam_mulai_pelajaran
                    Gateway->>DB: Simpan record presensi sementara (pending biometrik)
                    Gateway-->>AppGuru: 200 OK + terlambatmenit
                    AppGuru-->>Guru: Tampilkan status "Menunggu Verifikasi Wajah"
                    Gateway->>AppSiswa: Trigger FCM High-Priority Push (≤ 1 detik) untuk SYS-UC-003
                end
            end
        end
    end
```

---

## 3. API Contract

### 3.1 POST /api/v1/scan/validate

Validasi hasil pemindaian barcode oleh Guru Mapel dan kalkulasi keterlambatan.

**Request Headers:**

| Header | Value |
| --- | --- |
| Content-Type | application/json |
| Authorization | Bearer \<jwt_token_guru\> |

**Request Body:**

```json
{
  "payload_scanned": "string (base64, required)",
  "signature_hmac": "string (required)",
  "jadwal_id": "int (required)",
  "gps_guru": {
    "lat": -7.826,
    "lng": 110.328
  }
}
```

**Success Response (200 OK):**

```json
{
  "success": true,
  "data": {
    "presensi_id": 5521,
    "siswa_id": 1042,
    "terlambatmenit": 6,
    "status_sementara": "Menunggu Verifikasi Wajah"
  },
  "message": "Scan validated"
}
```

**Error Response (401 Unauthorized — signature/device tidak valid):**

```json
{
  "success": false,
  "data": null,
  "message": "Payload tidak valid atau terindikasi manipulasi",
  "errors": []
}
```

**Error Response (403 Forbidden — di luar Geofence):**

```json
{
  "success": false,
  "data": null,
  "message": "Gawai Guru berada di luar radius toleransi sekolah",
  "errors": []
}
```

---

### 3.2 GET /api/v1/geofence/check

Validasi posisi GPS Guru terhadap titik sekolah sebelum modul kamera diaktifkan.

**Request Headers:**

| Header | Value |
| --- | --- |
| Authorization | Bearer \<jwt_token_guru\> |

**Success Response (200 OK):**

```json
{
  "success": true,
  "data": { "in_range": true, "distance_meter": 42 },
  "message": "Within school geofence"
}
```

---

## 4. Data Flow

| Step | Input | Process | Output |
| --- | --- | --- | --- |
| 1 | GPS Guru | Geofence Validator (radius ≤ 100m) | Izin/blokir akses kamera |
| 2 | Timestamp_Epoch, DeviceID_Siswa, GeoHash | AES_256_CBC encryption (sisi Siswa) | Payload_Encrypted (refresh 30 detik) |
| 3 | Payload_Encrypted | HMAC_SHA256 signing (sisi Server) | Signature_HMAC |
| 4 | Payload hasil scan Guru | Dekripsi + verifikasi HMAC + cocokkan hardware binding | Payload valid/ditolak |
| 5 | Waktu scan sukses, jam_mulai_pelajaran master | Kalkulasi selisih waktu | `terlambatmenit` |
| 6 | Presensi_id valid | Trigger FCM High-Priority Push | Sinyal ke SYS-UC-003 (Liveness Detection) |

---

## 5. Security Rules

| Rule | Description |
| --- | --- |
| Signature Mismatch | `Signature_HMAC` tidak cocok → payload ditolak, dianggap manipulasi/spoofing, tidak diproses lebih lanjut |
| Hardware Binding Check | `DeviceID_Siswa` wajib cocok dengan data hardware binding terdaftar sebelum diproses |
| Offline Standby Buffer | Jika jaringan sekolah terputus, payload disimpan terenkripsi lokal pada gawai Guru dan disinkronkan otomatis pasca-koneksi pulih (SRS-NFR-004) |
| Universal Scanner Restriction | Pemindaian via aplikasi kamera pihak ketiga (di luar ekosistem, mis. Google Lens) hanya menghasilkan string acak tidak tereksekusi |
| Refresh Cycle | Barcode disegarkan otomatis setiap 30 detik dari memory buffer gawai untuk mencegah distribusi kode ke luar kelas |
| Geofence Tolerance | Kamera pemindai Guru hanya aktif jika GPS berada dalam radius toleransi ≤ 100 meter dari titik sekolah (SRS-FR-MAPEL-002) |

---

## 6. Traceability

| User Flow | Requirement | API Endpoint |
| --- | --- | --- |
| userflow_uc_002.md | SRS-FR-MAPEL-001, SRS-FR-MAPEL-002, SRS-FR-SWS-001, SRS-FR-SWS-004, SRS-NFR-004 | POST /api/v1/scan/validate, GET /api/v1/geofence/check |

## 7. Dependensi

- SYS-UC-001 (token JWT Guru harus valid sebelum modul scanner dapat diakses).
- SYS-UC-003 (kelanjutan proses menuju verifikasi biometrik wajah).
