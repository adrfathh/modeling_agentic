# UC-001: Login Pengguna (Semua Aktor) & RBAC Routing

**Aktor:** Admin IT, Guru Mapel, Siswa (Mobile) / Orang Tua, Kepala Sekolah (Web)

## Pre-condition
- Pengguna telah memiliki akun terdaftar pada sistem sesuai role masing-masing.
- Untuk Siswa: gawai sudah melewati proses Hardware Binding (UUID/IMEI) oleh Admin IT pada login pertama kali.
- Perangkat memiliki koneksi jaringan aktif untuk proses verifikasi token ke API Gateway.

## Main Flow
1. Pengguna membuka aplikasi (Mobile untuk Admin IT/Guru/Siswa, Web untuk Orang Tua/Kepala Sekolah) dan diarahkan ke halaman `/login`.
2. Pengguna memasukkan kredensial (username/email dan password).
3. Sistem mengirim request otentikasi ke API Gateway Backend.
4. Backend memverifikasi kredensial dan menerbitkan token JWT yang memuat klaim role pengguna.
5. API Gateway memvalidasi klaim role di dalam token JWT.
6. Sistem mengarahkan (routing) pengguna secara dinamis menuju dashboard eksklusif sesuai role:
   - Admin IT → `/dashboard-admin`
   - Guru Mapel → `/dashboard-guru`
   - Siswa → `/dashboard-siswa`
   - Orang Tua/Wali Murid → `/dashboard-orangtua`
   - Kepala Sekolah → `/dashboard-kepsek`
7. Token JWT disimpan pada sesi aktif pengguna dan disertakan pada setiap request berikutnya untuk validasi ulang oleh API Gateway.

## Alternative/Exception Flow
- **Jika kredensial salah**: Sistem menolak login dan menampilkan pesan error, tanpa menerbitkan token JWT.
- **Jika pengguna mencoba mengakses route/modul di luar role-nya (akses lintas modul)**: Sistem otomatis memicu pembatalan sesi (session termination) dan mengarahkan kembali ke `/login` (SRS-ARCH-002).
- **Jika token JWT kedaluwarsa di tengah sesi**: Setiap request berikutnya ditolak oleh API Gateway; pengguna wajib login ulang.
- **Fitur "Lupa Password"**: Tidak tersedia — di luar cakupan sistem (Out-of-Scope).

## Post-condition
Pengguna berhasil masuk ke dashboard sesuai role, dengan sesi JWT aktif yang divalidasi ulang oleh API Gateway pada setiap request berikutnya (SRS-ARCH-003).
