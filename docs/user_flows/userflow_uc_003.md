# UC-003: Face Liveness Detection (2FA)

**Aktor:** Siswa/Murid

## Pre-condition
- Siswa telah menyelesaikan proses pemindaian barcode oleh Guru Mapel (lihat UC-002), dan sistem telah memvalidasi HMAC signature serta hardware binding UUID.
- Gawai siswa memenuhi ambang batas minimum perangkat keras: sistem operasi Android 9 (Pie) atau iOS 13, RAM ≥ 3 GB, kamera depan resolusi minimal 5 Megapiksel dengan kompensasi eksposur otomatis (SRS-NFR-003).
- Sesi JWT internal siswa masih berlaku (belum kedaluwarsa).

## Main Flow
1. API Gateway Backend menerima payload hasil scan barcode guru dan mengalkulasi variabel `terlambatmenit`.
2. Firebase Service (FCM) memicu penembakan sinyal dorong berprioritas tinggi (High-Priority Push Notification) ke token registrasi gawai siswa target, wajib tuntas dalam waktu ≤ 1 detik.
3. Modul background receiver (Mobile App Listener) pada gawai siswa menangkap sinyal push, menguji masa berlaku sesi JWT internal, dan langsung mengaktifkan kamera depan native — tanpa memerlukan ketukan manual siswa.
4. Native Window Manager menyuntikkan parameter keamanan `FLAG_SECURE` (Android) / Screen Recording Protection API (iOS) ke jendela kamera aktif, memblokir total fungsi screenshot, perekaman layar, dan injeksi virtual stream.
5. Engine liveness lokal memetakan wajah siswa ke dalam matriks 68-Facial Landmarks dan menghitung nilai Eye Aspect Ratio (EAR):
   `EAR = (|p₂ - p₆| + |p₃ - p₅|) / (2 × |p₁ - p₄|)`
6. Sistem menguji kedipan valid: EAR ≤ 0.2 selama durasi mikro 0.15 detik.
7. Sistem secara paralel meluncurkan Challenge-Response Dinamis: instruksi pergerakan pupil mata mengikuti titik sirkular virtual, atau penolehan sudut kepala sebesar ±15°, dengan batas toleransi waktu 3 detik.
8. Jika kedipan valid terdeteksi dan tantangan acak berhasil diselesaikan dalam jendela waktu, otentikasi dinyatakan sukses.
9. Status presensi siswa bermutasi menjadi **Hadir** (`#48BB78`) atau **Terlambat** (`#ECC94B`) jika `terlambatmenit` > 0.

## Alternative/Exception Flow
- **Jika siswa gagal melewati tantangan challenge-response dalam 3 detik**: Subsistem keamanan otomatis memicu counter kegagalan (Count_fail bertambah 1).
- **Jika koordinat wajah tidak teridentifikasi akibat kendala cahaya redup**: Subsistem keamanan otomatis memicu counter kegagalan.
- **Jika Count_fail mencapai ≥ 3 (gagal 3 kali berturut-turut)**: Freeze State = TRUE. Gawai siswa mengeksekusi isolasi mandiri lokal — modul penampil barcode dimatikan total, generator token enkripsi dihapus dari memori volatil, dan seluruh layar antarmuka bermutasi menjadi warna ungu indigo penuh (`#805AD5`). Pemulihan hanya dapat dilakukan oleh Admin IT secara fisik (lihat UC-005).
- **Jika biometrik dipicu tanpa melalui closed-loop handshake dari backend**: Dilarang keras; siklus tidak boleh diinisiasi sepihak dari sisi gawai siswa untuk mengeliminasi celah bypass lokal atau serangan injeksi manipulasi stream kamera.

## Post-condition
Status presensi final (Hadir/Terlambat) tersimpan di database pusat. Jendela kamera ditutup, dan hasil verifikasi dikonsolidasikan menuju Web Portal untuk disajikan pada Dashboard Orang Tua (Donut Chart) dan Dashboard Kepala Sekolah (Grafik Analitik) — lihat UC-006.
