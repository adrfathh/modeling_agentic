# INDEKS LOGIKA SISTEM (SYSTEM LOGICS)
## Sistem Presensi Kehadiran Siswa Berbasis Kelas (Zero-Trust Attendance Protocol)
**Institusi:** SMA Muhammadiyah Kasihan

Dokumen ini memuat logika pemrosesan sisi backend/server untuk setiap use case, sebagai pasangan teknis dari folder `user_flows/` yang berfokus pada interaksi pengguna. Setiap `sys_uc_XXX.md` menjelaskan **input, algoritma/aturan pemrosesan, output, dan penanganan error** dari sudut pandang sistem — bukan langkah interaksi antarmuka.

| Kode | Nama Logika Sistem | User Flow Terkait |
|---|---|---|
| SYS-UC-001 | Logika Autentikasi JWT & RBAC Routing | `userflow_uc_001.md` |
| SYS-UC-002 | Logika Enkripsi Barcode, Validasi HMAC & Kalkulasi `terlambatmenit` | `userflow_uc_002.md` |
| SYS-UC-003 | Algoritma Liveness Detection (EAR & Challenge-Response) | `userflow_uc_003.md` |
| SYS-UC-004 | Logika Audit Trail Bypass Manual Guru | `userflow_uc_004.md` |
| SYS-UC-005 | Logika Reset Freeze State & Unfreeze Counter | `userflow_uc_005.md` |
| SYS-UC-006 | Logika Agregasi Data Analitik & Klausul Integritas Data | `userflow_uc_006.md` |

## Prinsip Umum Logika Sistem

1. **Zero-Trust per Request**: Tidak ada state kepercayaan yang dipertahankan antar-request. Setiap request (presensi, pemindaian wajah, mutasi konfigurasi kelas) wajib divalidasi ulang klaim JWT-nya oleh API Gateway (SRS-ARCH-003).
2. **Closed-Loop Handshake**: Proses sensitif (misalnya trigger kamera biometrik) hanya boleh diinisiasi oleh backend, tidak boleh dipicu sepihak dari sisi gawai klien.
3. **Immutable Audit Trail**: Setiap aksi manual/bypass wajib mencatat metadata audit (GPS, UUID gawai, timestamp) yang tidak dapat diubah pasca-submit.
4. **Data Integrity Gate**: Data berstatus belum final ("Waiting for Approval", "Offline Mode") wajib difilter di lapisan agregasi sebelum mencapai endpoint dashboard analitik.
