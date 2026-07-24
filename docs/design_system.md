# DESIGN SYSTEM
## Sistem Presensi Kehadiran Siswa Berbasis Kelas (Zero-Trust Attendance Protocol)
**Institusi:** SMA Muhammadiyah Kasihan
**Sumber Acuan:** Design System Specification V5, Integrated User Flow Blueprint V7.0, Technical Specification Face Biometrics V2.0

---

## a. Warna (Color Palette)

Token warna fungsional berikut bersifat eksklusif dan wajib digunakan secara konsisten di seluruh gawai lapangan (Mobile) dan Web Portal untuk menjaga auditabilitas data:

| Token | Hex | Fungsi |
|---|---|---|
| **Active Primary** | `#3182CE` (Blue) | Elemen navigasi aktif (garis bawah tab, kartu siswa terpilih pada form dispensasi darurat) |
| **Attend/Approve** | `#48BB78` (Green) | Status presensi sah (Hadir) — lolos validasi biometrik atau disetujui manual Admin IT |
| **Waiting/Freeze** | `#805AD5` (Purple) | Gawai siswa terkunci (Freeze State) atau antrean presensi darurat menunggu persetujuan ("Waiting for Approval") |
| **Absent/Reject** | `#E53E3E` (Red) | Ketidakhadiran tanpa keterangan sah (Alpa) atau penolakan otentikasi perangkat |
| **1/2 Day/Late** | `#ECC94B` (Yellow) | Keterlambatan (`terlambatmenit` > 0) atau status dispensasi setengah hari (Sakit/Izin) |
| **Unavailable/Offline** | `#A0AEC0` (Gray) | Mode luring (Offline Mode) saat aplikasi Guru menyimpan cache data lokal akibat gangguan internet |

> **Klausul Integritas**: Data berwarna `#805AD5` (Waiting for Approval) dan `#A0AEC0` (Offline Mode) dilarang keras dirender ke dalam komponen analitik makro (Donut Chart Orang Tua, Grafik Batang Kepala Sekolah) sebelum diverifikasi resmi oleh Admin IT.

---

## b. Tipografi

Dokumen sumber (Design System V5, User Flow Blueprint V7.0) tidak mencantumkan nama font family, ukuran heading (H1–H6), maupun spesifikasi line-height/paragraf secara eksplisit. Ketentuan yang secara eksplisit dimandatkan hanya terbatas pada aturan berikut:

- Angka persentase pada Donut Chart (Dashboard Orang Tua/Kepala Sekolah) wajib ditampilkan sebagai **teks numerik tebal berukuran besar** di pusat grafik (contoh: `95%`).
- Label sub-judul keterangan di bawah angka Donut Chart wajib tampil sebagai **teks tipis** (contoh: "Today's Attendance Percentage").

Untuk detail typografi lainnya (font family, skala heading H1–H6, ukuran paragraf, line-height, weight), belum terdapat ketentuan eksplisit dalam dokumen referensi. Tim desain wajib menetapkannya pada tahap UI Kit lanjutan tanpa bertentangan dengan aturan kontras teks tebal/tipis di atas.

---

## c. Komponen UI

### Tab Navigation
- Garis bawah aktif berwarna **#3182CE** menandai tab yang sedang dipilih.
- Struktur tab linier horizontal tanpa sekat kaku, mengikuti taksonomi: **Daily**, **Payroll Schedule**, **Monthly**.
- Sub-header tanggal dengan kontrol navigasi panah kiri-kanan (contoh: `< Sun 10 - Sat 23 November 2025 >`).

### Halaman Barcode Dinamis Siswa
- Wajib menyuntikkan pengunci jendela asinkron native: `FLAG_SECURE` (Android) / Screen Recording Protection API (iOS).
- Layar otomatis menjadi pekat/hitam jika terdeteksi usaha perekaman atau tangkapan layar.
- Di bawah kontainer barcode terdapat ring hitung mundur sirkular interaktif berdurasi **30 detik** sebelum siklus penyegaran token.

### Kamera Pemindai Guru
- Jendela kamera pembaca hanya terbuka jika Geofence Validator mengembalikan status sukses (radius toleransi ≤ 100 meter).
- Bilah status atas aplikasi Guru wajib menampilkan lencana visual abu-abu bertuliskan **"Offline Mode"** ketika jaringan terputus.

### Komponen Lini Masa Riwayat Presensi Vertikal (Attendance History)

| Status Kehadiran | Warna | Elemen Karakteristik & Metadata |
|---|---|---|
| Unavailable | `#A0AEC0` | Titik abu-abu tipis; info teks jadwal jam pelajaran belum dimulai |
| Waiting for Approval | `#805AD5` | Titik ungu sirkular; log antrean bypass manual guru menunggu verifikasi server |
| Attend (Hadir) | `#48BB78` | Titik hijau stabilo; teks "Auto approved", timestamp presisi (HH:MM WIB), log sinkronisasi |
| 1/2 Day (Izin/Sakit) | `#ECC94B` | Titik kuning emas; alasan, durasi menit, tombol tempat sampah (khusus Admin IT) untuk reset/hapus |
| Absent (Alpa) | `#E53E3E` | Titik merah; keterangan ketidakhadiran tanpa keterangan sah |

### Donut Chart Metrik Persentase (Web Portal)
- Wajib digunakan pada Dashboard Orang Tua dan Kepala Sekolah untuk merender persentase kumulatif kehadiran.
- Pusat grafik: teks numerik tebal besar (contoh: `95%`).
- Sub-judul di bawah angka: teks tipis "Today's Attendance Percentage".

### Modul Super-View Analitik (Kepala Sekolah)
- **Grafik Batang Indeks Keterlambatan**: mengakumulasi peringkat siswa berdasarkan `terlambatmenit` kumulatif tertinggi.
- **Grafik Distribusi Alpa**: visualisasi komparatif ketidakhadiran antar-kelas, sekaligus penyuplai pipeline ekspor .xlsx ke Dapodik.

> Catatan: Dokumen sumber tidak menyebutkan spesifikasi eksplisit untuk komponen Button (bentuk sudut, warna hover, ukuran), Input Form (gaya border, focus state), maupun Card & Table (shadow, padding). Elemen-elemen ini belum ditetapkan sebagai Source of Truth dan perlu didefinisikan pada iterasi UI Kit berikutnya agar tidak menambahkan asumsi di luar referensi.

---

## d. State Management Visual

Dokumen sumber secara eksplisit hanya mendefinisikan state berikut, yang seluruhnya terintegrasi dengan token warna fungsional:

- **Unavailable State** (`#A0AEC0`): Titik abu-abu tipis pada lini masa presensi, menampilkan info bahwa jadwal jam pelajaran belum dimulai.
- **Offline/Waiting State**:
  - `#A0AEC0` (Offline Mode) — lencana abu-abu pada bilah status Guru saat jaringan terputus; data scan tersimpan di cache lokal sebelum sinkronisasi.
  - `#805AD5` (Waiting for Approval) — status presensi darurat dari bypass Guru yang menunggu verifikasi Admin IT; juga digunakan sebagai tampilan penuh (spanduk ungu blokir) saat gawai siswa memasuki Freeze State.
- **Error/Blokir State**: Layar kamera Guru diblokir dengan pesan error jika GPS berada di luar Geofence sekolah; halaman barcode siswa otomatis menjadi pekat/hitam saat terdeteksi upaya tangkapan layar/perekaman.

Dokumen sumber tidak mendefinisikan secara eksplisit desain generik untuk Empty State (data kosong) maupun Loading State (spinner/skeleton) di luar konteks-konteks spesifik di atas. Ketentuan tambahan untuk kedua state tersebut perlu ditetapkan pada tahap UI Kit lanjutan.
