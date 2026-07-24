# SYS-UC-002: Logika Enkripsi Barcode, Validasi HMAC & Kalkulasi `terlambatmenit`

**User Flow Terkait:** `userflow_uc_002.md`

## Input
- Payload barcode hasil scan kamera Guru.
- Koordinat GPS gawai Guru (untuk validasi Geofence).
- Data master jam mulai pelajaran (input Admin IT).

## Proses / Algoritma
1. **Generasi Payload (sisi Siswa)**: Aplikasi siswa menghasilkan payload terenkripsi:
   `Payload_Encrypted = AES_256_CBC(Timestamp_Epoch || DeviceID_Siswa || GeoHash_Location)`
   Payload disegarkan otomatis setiap 30 detik dari memory buffer gawai.
2. **Penandatanganan (sisi Server)**: Server menghasilkan tanda tangan digital:
   `Signature_HMAC = HMAC_SHA256(Payload_Encrypted, K_Private_Secret)`
3. **Validasi Geofence (sisi Guru, prasyarat sebelum scan)**: Kamera pemindai Guru hanya aktif jika koordinat GPS gawai berada dalam radius toleransi ≤ 100 meter dari titik sekolah. Jika gagal → blokir akses kamera + log blokir.
4. **Dekripsi & Verifikasi (sisi Server, pasca-scan)**:
   - Server menerima payload hasil scan, mendekripsi dengan AES-256-CBC.
   - Server memvalidasi ulang `Signature_HMAC` menggunakan `K_Private_Secret`.
   - Server mencocokkan `DeviceID_Siswa` terhadap data hardware binding terdaftar.
5. **Kalkulasi `terlambatmenit`**:
   `terlambatmenit = waktu_sukses_scan − jam_mulai_pelajaran_master`
   Jika hasil ≤ 0, maka `terlambatmenit = 0` dan status berpotensi "Hadir"; jika > 0, status berpotensi "Terlambat".
6. Server memicu FCM High-Priority Push Notification ke gawai siswa untuk memulai SYS-UC-003 (Liveness Detection), dengan SLA transmisi ≤ 1 detik.

## Output
- Status validasi payload (valid/tidak valid).
- Nilai `terlambatmenit` tersimpan sebagai metadata presensi.
- Trigger sinyal FCM ke gawai siswa.

## Aturan Validasi / Error Handling
- Jika `Signature_HMAC` tidak cocok → payload ditolak, dianggap manipulasi/spoofing, tidak diproses lebih lanjut.
- Jika `DeviceID_Siswa` tidak cocok dengan hardware binding terdaftar → payload ditolak.
- Jika jaringan sekolah terputus saat proses scan (Offline Mode `#A0AEC0`): payload disimpan terenkripsi pada Offline Standby Buffer lokal gawai Guru dan disinkronkan otomatis pasca-koneksi pulih (SRS-NFR-004).
- Pemindaian via aplikasi kamera pihak ketiga (di luar ekosistem) hanya menghasilkan string acak tidak tereksekusi — bukan payload valid.

## Dependensi
- SYS-UC-001 (token JWT Guru harus valid sebelum modul scanner dapat diakses).
- SYS-UC-003 (kelanjutan proses menuju verifikasi biometrik).
