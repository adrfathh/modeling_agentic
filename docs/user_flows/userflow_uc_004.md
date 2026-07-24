# UC-004: Otorisasi Absen Manual Ter-Audit (Bypass Guru)

**Aktor:** Guru Mata Pelajaran

## Pre-condition
- Guru sudah login dan terautentikasi via token JWT.
- Terdapat siswa yang mengalami kendala teknis/pembekuan biometrik (Freeze State) atau gawai rusak sehingga tidak dapat menyelesaikan siklus presensi normal (UC-002/UC-003).
- Guru berada dalam jadwal mengajar aktif pada kelas yang bersangkutan.

## Main Flow
1. Guru mengakses tab **"Payroll Schedule"** pada gawai mobile miliknya.
2. Guru memilih nama siswa yang mengalami kendala biometrik pada daftar nama kelas digital.
3. Guru mengklik tombol otorisasi manual, memicu form **Otorisasi Absen Manual Ter-Audit**. Kartu nama siswa bertransisi menjadi warna biru aktif (`#3182CE`).
4. Guru memilih dispensasi status kehadiran (Hadir, Izin, Sakit, atau Alfa) pada Form Modifikasi Status Kehadiran.
5. Guru wajib menginput log deskripsi kendala lapangan (Form Log Kendala Teknis & Alasan Bypass).
6. Sistem secara otomatis menyuntikkan koordinat GPS poligon sekolah dan tanda tangan UUID gawai Guru ke dalam log sebagai metadata audit.
7. Status presensi siswa masuk ke dalam antrean warna ungu sirkular (`#805AD5`) bertuliskan **"Waiting for Approval"**.

## Alternative/Exception Flow
- **Jika Guru tidak mengisi deskripsi log alasan kendala**: Sistem wajib menahan submission form hingga field deskripsi terisi (field wajib).
- **Jika koordinat GPS Guru tidak dapat diambil**: Metadata audit tidak lengkap; proses otorisasi manual tidak dapat dilanjutkan tanpa pencatatan koordinat GPS poligon sekolah.
- **Jika status "Waiting for Approval" belum diverifikasi Admin IT**: Data ini dilarang keras ditarik masuk atau dihitung ke dalam komponen analitik Donut Chart Orang Tua maupun grafik batang Kepala Sekolah (lihat UC-006).

## Post-condition
Log presensi manual tersimpan dengan status "Waiting for Approval" (`#805AD5`), lengkap dengan metadata audit (koordinat GPS, UUID gawai Guru, deskripsi alasan). Data menunggu persetujuan/verifikasi resmi dari Admin IT sebelum dapat direkonsiliasi ke dashboard analitik Orang Tua dan Kepala Sekolah.
