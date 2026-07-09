# SYS-UC-001: Logika Autentikasi JWT & RBAC Routing

**User Flow Terkait:** `userflow_uc_001.md`

## Input
- Kredensial pengguna (username/email, password).
- Metadata request (device info, timestamp).

## Proses / Algoritma
1. Backend menerima request login dan memverifikasi kredensial terhadap basis data pengguna.
2. Jika valid, backend menerbitkan token JWT yang memuat klaim `role` (Admin IT / Guru Mapel / Siswa / Orang Tua / Kepala Sekolah) dan `user_id`.
3. Token JWT dikembalikan ke klien dan disimpan pada sesi aktif.
4. Pada **setiap request berikutnya** (bukan hanya saat login), API Gateway wajib:
   - Memvalidasi tanda tangan dan masa berlaku token JWT.
   - Mencocokkan klaim `role` terhadap modul/endpoint yang diakses (RBAC check).
5. Jika klaim role tidak sesuai dengan modul yang diminta (akses lintas modul), API Gateway wajib:
   - Menolak request (HTTP 403 / setara).
   - Memicu pembatalan sesi (session termination) secara otomatis pada level backend.

## Output
- Token JWT valid dengan klaim role tersemat → routing dinamis ke dashboard eksklusif role.
- Penolakan request + session termination jika validasi RBAC gagal.

## Aturan Validasi / Error Handling
- **SRS-ARCH-001**: RBAC wajib diimplementasikan ketat pada level backend dan frontend.
- **SRS-ARCH-002**: Akses lintas modul role dilarang keras; otomatis memicu session termination.
- **SRS-ARCH-003**: Klaim role dalam JWT divalidasi ulang oleh API Gateway pada **setiap** request siklus presensi, pemindaian wajah, maupun mutasi database konfigurasi kelas — bukan hanya pada saat login.

## Dependensi
- Modul Hardware Binding (untuk validasi tambahan pada login Siswa).
- Seluruh modul lain (SYS-UC-002 s.d SYS-UC-006) bergantung pada output token JWT tervalidasi dari logika ini sebagai prasyarat eksekusi.
