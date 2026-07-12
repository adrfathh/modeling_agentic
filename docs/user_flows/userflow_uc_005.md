# UC-005: Unfreeze Akun Siswa

**Aktor:** Administrator/Tim IT Sekolah

## Pre-condition
- Gawai siswa berada dalam kondisi Freeze State (`#805AD5`) akibat Count_fail ≥ 3 pada verifikasi Face Liveness Detection (UC-003).
- Admin IT sudah login dan terautentikasi via token JWT dengan role Admin IT.
- Siswa telah membawa gawai fisiknya secara langsung ke ruang IT sekolah pasca-KBM berjalan selesai (pemulihan remote dilarang keras).

## Main Flow
1. Siswa membawa perangkat fisiknya secara langsung menuju ruang IT pasca-KBM berjalan selesai.
2. Admin IT membuka gerbang antarmuka Administrator pada codebase gawai terpadu (`/dashboard-admin`).
3. Admin IT mengakses widget **Log Keamanan Sistem Terkini** (`/unfreeze`), yang memuat Log Pendeteksi Status Freeze State (riwayat gagal biometrik wajah 3x).
4. Admin IT memverifikasi rekaman kegagalan kamera siswa secara manual dan memeriksa integritas fisik gawai siswa secara langsung.
5. Admin IT mengeksekusi perintah fungsional **"Unfreeze Akun"**.
6. Sistem secara asinkron membersihkan memory buffer gawai siswa dan mereset nilai `Count_fail = 0`.
7. Sistem mengembalikan status penampil barcode gawai siswa menuju kondisi operasional normal, membersihkan tanda pembekuan.

## Alternative/Exception Flow
- **Jika Admin IT mencoba melakukan unfreeze dari jarak jauh (remote)**: Dilarang keras oleh sistem; proses pemulihan wajib mematuhi protokol mobilitas lapangan dengan kehadiran fisik gawai siswa.
- **Jika integritas fisik gawai siswa tidak dapat diverifikasi (misalnya indikasi kerusakan/manipulasi)**: Admin IT tidak dapat melanjutkan proses unfreeze hingga verifikasi fisik tuntas.

## Post-condition
Status enkripsi gawai siswa kembali ke kondisi operasional normal; siswa dapat kembali menghasilkan barcode dinamis dan menjalani Face Liveness Detection (UC-002/UC-003) pada siklus presensi berikutnya. Riwayat log unfreeze tercatat dan dapat dipantau oleh Kepala Sekolah melalui Sub-View Riwayat Log Unfreeze Akun (Read-Only Total) — lihat UC-006.
