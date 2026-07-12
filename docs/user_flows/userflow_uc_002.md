# UC-002: Siklus Pemindaian Barcode Presensi (Siswa & Guru)

**Aktor:** Guru Mata Pelajaran, Siswa

## Pre-condition
- Guru sudah login dan terautentikasi via token JWT.
- Guru berada dalam Geofence sekolah (radius toleransi ≤ 100 meter).
- Siswa sudah membuka halaman barcode dinamis pada gawainya.

## Main Flow
1. Guru membuka aplikasi mobile, melewati validasi JWT, dan diarahkan ke tab **Daily** untuk melihat jadwal berjalan kelas fisik yang ditugaskan Admin IT.
2. Guru memilih jam pelajaran aktif di menu **Payroll Schedule**, memicu sistem menarik daftar siswa terikat (hardware binding) pada kelas tersebut.
3. Guru menekan tombol **"Mulai Pemindaian"**.
4. Sistem mengaktifkan modul kamera belakang native guru; jendela kamera pembaca hanya terbuka jika Geofence Validator mengembalikan status sukses.
5. Guru mengarahkan kamera ke barcode dinamis siswa (token terenkripsi AES-256-CBC yang menyegarkan diri setiap 30 detik).
6. Sistem memindai payload, mengirimkannya ke API Gateway Backend, lalu mendekripsi menggunakan algoritma AES-256-CBC.
7. Sistem memvalidasi tanda tangan digital HMAC-SHA256 dan mencocokkan UUID hardware binding.
8. Sistem menghitung variabel `terlambatmenit` berdasarkan selisih waktu sukses pemindaian terhadap jam mulai pelajaran resmi yang diinput Admin IT.
9. Sistem (Firebase Service/FCM) mengirim sinyal High-Priority Push Notification ke gawai siswa target, wajib tuntas dalam waktu ≤ 1 detik, memicu lanjutan ke UC-003 (Face Liveness Detection).
10. Jika verifikasi biometrik sukses, status presensi siswa bermutasi menjadi **Hadir** (`#48BB78`) atau **Terlambat** (`#ECC94B`) jika `terlambatmenit` > 0.

## Alternative/Exception Flow
- **Jika GPS Guru di luar Geofence**: Akses kamera diblokir; sistem menampilkan pesan error dan mencatat log informasi blokir akses kamera.
- **Jika jaringan sekolah terputus (Offline Mode)**: Data scan tersimpan terenkripsi pada Offline Standby Buffer lokal gawai Guru (`#A0AEC0`); alur biometrik wajah ditunda hingga jaringan pulih, lalu disinkronisasikan secara otomatis ke server cloud.
- **Jika Face Liveness Detection gagal 3 kali berturut-turut (Count_fail ≥ 3)**: Gawai siswa masuk ke Freeze State (`#805AD5`); lihat UC-005 untuk alur pemulihan.
- **Jika siswa tidak memiliki barcode/token tidak valid**: Sistem menampilkan pesan error pemindaian gagal.
- **Jika pemindaian dilakukan menggunakan aplikasi kamera pihak ketiga (di luar ekosistem)**: Hanya menghasilkan representasi string acak yang tidak tereksekusi.

## Post-condition
Data presensi tersimpan di database pusat dan terlihat pada lini masa riwayat presensi. Data hanya boleh dirender ke Dashboard Orang Tua dan Kepala Sekolah setelah berstatus final terverifikasi (bukan "Waiting for Approval" atau "Offline Mode").
