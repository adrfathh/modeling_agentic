# PETA ALUR PENGGUNA (USER FLOW INDEX)
## Sistem Presensi Kehadiran Siswa Berbasis Kelas (Zero-Trust Attendance Protocol)
**Institusi:** SMA Muhammadiyah Kasihan

> Catatan revisi: Penomoran use case pada versi ini disusun ulang menjadi UC-001 s.d UC-006 agar selaras 1:1 dengan folder `system_logics/` — setiap kode UC merepresentasikan alur yang sama, dilihat dari dua sisi: **user_flows** (perspektif interaksi pengguna) dan **system_logics** (perspektif logika/algoritma backend).

| Kode | Nama Use Case | Aktor Utama | Platform |
|---|---|---|---|
| UC-001 | Login Pengguna (Semua Aktor) & RBAC Routing | Semua Aktor | Mobile & Web |
| UC-002 | Siklus Pemindaian Barcode Presensi (Siswa & Guru) | Siswa, Guru Mapel | Mobile |
| UC-003 | Face Liveness Detection (2FA) | Siswa | Mobile |
| UC-004 | Otorisasi Absen Manual Ter-Audit (Bypass Guru) | Guru Mapel | Mobile |
| UC-005 | Unfreeze Akun Siswa | Admin IT | Mobile |
| UC-006 | Monitoring, Analitik & Export Dapodik | Orang Tua, Kepala Sekolah | Web |

## Referensi Silang ke system_logics/

| User Flow | Logika Sistem Terkait |
|---|---|
| `userflow_uc_001.md` | `sys_uc_001.md` — Logika Autentikasi JWT & RBAC Routing |
| `userflow_uc_002.md` | `sys_uc_002.md` — Logika Enkripsi Barcode, Validasi HMAC & Kalkulasi `terlambatmenit` |
| `userflow_uc_003.md` | `sys_uc_003.md` — Algoritma Liveness Detection (EAR & Challenge-Response) |
| `userflow_uc_004.md` | `sys_uc_004.md` — Logika Audit Trail Bypass Manual |
| `userflow_uc_005.md` | `sys_uc_005.md` — Logika Reset Freeze State & Unfreeze Counter |
| `userflow_uc_006.md` | `sys_uc_006.md` — Logika Agregasi Data Analitik & Klausul Integritas |

Seluruh alur bersumber dari SRS V2, IA V2.1, Design System V5, Integrated User Flow Blueprint V7.0, dan Technical Specification Face Biometrics & Liveness Detection V2.0.
