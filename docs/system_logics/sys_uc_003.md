# System Logic: SYS-UC-003 Algoritma Liveness Detection (EAR & Challenge-Response)

Document Version: v2.0

Use Case ID: SYS-UC-003

Use Case Name: Algoritma Liveness Detection (EAR & Challenge-Response)

Status: Draft

Last Updated: 2026-07-12

Author: System Analyst AI

User Flow Terkait: `userflow_uc_003.md`

---

## 1. Overview

Dokumen ini mendefinisikan logika Faktor Otentikasi Kedua (2FA) berbasis Face Recognition & Face Liveness Detection pada gawai siswa. Proses bersifat closed-loop handshake: hanya dapat dipicu oleh backend (via FCM push) pasca-scan barcode sukses (SYS-UC-002), tidak boleh diinisiasi sepihak dari sisi klien.

---

## 2. Sequence Diagram

```mermaid
sequenceDiagram
    participant Gateway as API Gateway (dari SYS-UC-002)
    participant FCM as Firebase Cloud Messaging
    participant AppSiswa as App Siswa (Mobile)
    actor Siswa
    participant Camera as Native Camera Module
    participant DB as Database

    Gateway->>FCM: Kirim High-Priority Push Notification (target: DeviceID Siswa)
    FCM->>AppSiswa: Trigger sinyal asinkron (SLA ≤ 1 detik)
    AppSiswa->>AppSiswa: Background receiver validasi masa berlaku JWT internal

    alt Pre-check hardware gagal (RAM < 3GB / OS < Android 9 / iOS 13 / kamera < 5MP)
        AppSiswa-->>Siswa: Tampilkan error hardware tidak memenuhi syarat
        AppSiswa->>Gateway: Report kegagalan pre-check
    else Pre-check hardware lolos (SRS-NFR-003)
        AppSiswa->>Camera: Aktifkan kamera depan native (tanpa ketukan manual)
        Camera->>Camera: Suntik FLAG_SECURE / Screen Recording Protection API
        Camera-->>Siswa: Jendela kamera terbuka penuh

        Camera->>Camera: Ekstraksi 68-Facial Landmarks
        Camera->>Camera: Hitung EAR = (|p2-p6| + |p3-p5|) / (2 × |p1-p4|)
        AppSiswa-->>Siswa: Tampilkan instruksi Challenge-Response (pupil/kepala ±15°, batas 3 detik)
        Siswa->>Camera: Kedipan mata & respons gerakan

        alt EAR ≤ 0.2 selama 0.15 detik DAN challenge selesai dalam 3 detik
            Camera->>AppSiswa: Liveness = TRUE
            AppSiswa->>Gateway: POST /api/v1/biometric/verify (hasil: sukses)
            Gateway->>DB: Update presensi_id → status final (Hadir/Terlambat berdasar terlambatmenit)
            Gateway-->>AppSiswa: 200 OK + status final
            AppSiswa-->>Siswa: Tampilkan konfirmasi presensi berhasil
        else Liveness gagal / wajah tidak teridentifikasi
            Camera->>AppSiswa: Liveness = FALSE
            AppSiswa->>Gateway: POST /api/v1/biometric/verify (hasil: gagal)
            Gateway->>DB: Count_fail += 1
            Gateway-->>AppSiswa: 200 OK + Count_fail terkini

            alt Count_fail < 3
                AppSiswa-->>Siswa: Tampilkan "Coba lagi" (retry biometrik)
            else Count_fail >= 3
                Gateway->>DB: Set Freeze State = TRUE (lanjut ke SYS-UC-005)
                Gateway-->>AppSiswa: 200 OK + freeze_state: true
                AppSiswa->>AppSiswa: Hapus token barcode dari memory buffer
                AppSiswa-->>Siswa: Layar bermutasi penuh warna ungu #805AD5
            end
        end
    end
```

---

## 3. API Contract

### 3.1 POST /api/v1/biometric/verify

Mengirim hasil pemrosesan lokal Face Liveness Detection ke backend.

**Request Headers:**

| Header | Value |
| --- | --- |
| Content-Type | application/json |
| Authorization | Bearer \<jwt_token_siswa\> |

**Request Body:**

```json
{
  "presensi_id": "int (required)",
  "ear_value": "number (required)",
  "challenge_response_result": "boolean (required)",
  "hasil_akhir": "string (enum: sukses, gagal, required)"
}
```

**Success Response (200 OK — verifikasi sukses):**

```json
{
  "success": true,
  "data": {
    "presensi_id": 5521,
    "status_final": "Terlambat",
    "terlambatmenit": 6,
    "count_fail": 0
  },
  "message": "Verifikasi biometrik berhasil"
}
```

**Success Response (200 OK — gagal, belum freeze):**

```json
{
  "success": true,
  "data": {
    "presensi_id": 5521,
    "status_final": null,
    "count_fail": 2,
    "freeze_state": false
  },
  "message": "Verifikasi gagal, silakan coba kembali"
}
```

**Response (200 OK — freeze terpicu):**

```json
{
  "success": true,
  "data": {
    "presensi_id": 5521,
    "count_fail": 3,
    "freeze_state": true
  },
  "message": "Gawai dibekukan setelah 3 kali gagal verifikasi"
}
```

---

## 4. Data Flow

| Step | Input | Process | Output |
| --- | --- | --- | --- |
| 1 | Sinyal FCM dari SYS-UC-002 | Background receiver + validasi JWT internal | Kamera depan aktif (≤ 1 detik) |
| 2 | Spesifikasi hardware gawai | Pre-check RAM/OS/kamera (SRS-NFR-003) | Izin/blokir modul biometrik |
| 3 | Stream kamera depan | Ekstraksi 68-Facial Landmarks + kalkulasi EAR | Nilai EAR real-time |
| 4 | Instruksi Challenge-Response | Deteksi gerakan pupil/kepala ±15° dalam 3 detik | Hasil challenge sukses/gagal |
| 5 | EAR + hasil challenge | Keputusan otentikasi biometrik | Status sukses/gagal + `Count_fail` |
| 6 | `Count_fail` | Uji kondisi `Count_fail >= 3` | Status presensi final ATAU Freeze State (→ SYS-UC-005) |

---

## 5. Security Rules

| Rule | Description |
| --- | --- |
| Closed-Loop Handshake | Modul biometrik dilarang keras dipicu dari inisiasi sepihak gawai siswa; wajib melalui trigger FCM dari backend |
| Native Screen Protection | `FLAG_SECURE` (Android) / Screen Recording Protection API (iOS) disuntikkan ke jendela kamera sebelum capture dimulai |
| EAR Threshold | Kedipan valid terdeteksi jika `EAR ≤ 0.2` bertahan selama `0.15` detik |
| Challenge Timeout | Challenge-response (pupil/kepala ±15°) wajib diselesaikan dalam jendela waktu 3 detik |
| Hardware Minimum | Modul biometrik hanya aktif jika OS ≥ Android 9 (Pie)/iOS 13, RAM ≥ 3GB, kamera depan ≥ 5MP (SRS-NFR-003) |
| Freeze Trigger | `Count_fail ≥ 3` memicu isolasi mandiri lokal: token barcode dihapus dari memory buffer, layar bermutasi penuh `#805AD5` |

---

## 6. Traceability

| User Flow | Requirement | API Endpoint |
| --- | --- | --- |
| userflow_uc_003.md | SRS-FR-SWS-002, SRS-FR-SWS-003, SRS-NFR-003 | POST /api/v1/biometric/verify |

## 7. Dependensi

- SYS-UC-002 (prasyarat: hasil scan barcode valid dan sinyal FCM diterima).
- SYS-UC-005 (jalur lanjutan jika Freeze State terpicu).
