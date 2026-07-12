# TEST PLAN
## Sistem Presensi Kehadiran Siswa Berbasis Kelas (Zero-Trust Attendance Protocol)
**Institusi:** SMA Muhammadiyah Kasihan

## 1. Tujuan Pengujian
Memastikan seluruh fitur in-scope pada `srs.md` berfungsi sesuai Business Rules yang ditetapkan, dengan penekanan khusus pada mekanisme anti-fraud (Geofence, HMAC, hardware binding), Freeze State/Unfreeze, dan Klausul Integritas Data sebelum sistem dinyatakan siap produksi.

## 2. Ruang Lingkup Pengujian

### In-Scope Pengujian
- Autentikasi JWT & RBAC routing lintas 5 role.
- Siklus lengkap presensi: generate barcode → scan Guru → validasi HMAC → liveness detection → status final.
- Geofence Validator (batas radius ≤ 100 meter).
- Freeze State (Count_fail ≥ 3) dan alur Unfreeze oleh Admin IT.
- Otorisasi Absen Manual Ter-Audit (bypass Guru) beserta metadata audit.
- Offline Standby Buffer & sinkronisasi otomatis.
- Klausul Integritas Data pada Dashboard Orang Tua dan Kepala Sekolah.
- Export laporan .xlsx untuk Dapodik.

### Out-of-Scope Pengujian
- Seluruh fitur yang tercantum sebagai Out-of-Scope pada `srs.md` (presensi gerbang terpusat, forgot password, payment gateway, remote unfreeze).
- Pengujian integrasi langsung ke sistem Dapodik nasional (hanya pengujian output format file .xlsx).

## 3. Strategi Pengujian

| Jenis Pengujian | Fokus |
|---|---|
| Functional Testing | Kesesuaian setiap fitur in-scope terhadap Business Rules SRS |
| Security & Anti-Fraud Testing | Validasi HMAC, enkripsi AES-256-CBC, hardware binding, anti-screenshot, Geofence, closed-loop handshake biometrik |
| Data Integrity Testing | Klausul filter status "Waiting for Approval"/"Offline Mode" pada dashboard analitik |
| Performance Testing | Beban 500 pemindaian paralel dalam 5 menit awal jam pelajaran (SRS-NFR-002) |
| Availability Testing | Validasi uptime backend selama jam KBM 07.00–16.00 WIB (SRS-NFR-001) |
| User Acceptance Testing (UAT) | Validasi alur end-to-end oleh perwakilan tiap role (Admin IT, Guru, Siswa, Orang Tua, Kepala Sekolah) |

## 4. Lingkungan Pengujian
- Perangkat mobile uji: minimum Android 9 (Pie) dan iOS 13, RAM ≥ 3 GB, kamera depan ≥ 5 MP (sesuai SRS-NFR-003).
- Simulasi koordinat GPS untuk pengujian Geofence (di dalam dan di luar radius 100 meter).
- Simulasi kondisi jaringan terputus untuk pengujian Offline Standby Buffer.
- Lingkungan staging backend dengan API Gateway dan modul FCM aktif.

## 5. Kriteria Masuk (Entry Criteria)
- Seluruh modul in-scope pada `srs.md` telah selesai diimplementasikan pada lingkungan staging.
- `data_model.md` dan `system_logics/` telah diimplementasikan sesuai spesifikasi.

## 6. Kriteria Keluar (Exit Criteria)
- Seluruh test case pada `test_cases.md` berstatus Pass, atau defect yang tersisa telah disetujui sebagai Known Issue non-blocking oleh pemangku kepentingan.
- Tidak ada defect kritikal terkait Klausul Integritas Data atau mekanisme anti-fraud yang belum terselesaikan.

## 7. Peran & Tanggung Jawab
- **Tim QA**: Menyusun dan mengeksekusi `test_cases.md`, mencatat hasil pada `test_execution_sheet.md`.
- **Admin IT (perwakilan sekolah)**: Berpartisipasi pada UAT modul Hardware Binding dan Unfreeze.
- **Guru & Siswa (perwakilan)**: Berpartisipasi pada UAT siklus presensi kelas.

## 8. Risiko Pengujian
- Simulasi lingkungan sekolah nyata (radius Geofence, kondisi cahaya kelas untuk liveness detection) memerlukan pengujian lapangan langsung, tidak sepenuhnya dapat direplikasi di lingkungan staging.
- Ketergantungan terhadap layanan pihak ketiga (FCM) memerlukan koordinasi jadwal pengujian dengan ketersediaan layanan tersebut.
