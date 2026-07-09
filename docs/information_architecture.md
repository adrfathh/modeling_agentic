# INFORMATION ARCHITECTURE (IA)
## Sistem Presensi Kehadiran Siswa Berbasis Kelas (Zero-Trust Attendance Protocol)
**Institusi:** SMA Muhammadiyah Kasihan
**Sumber Acuan:** IA V2.1, Design System V5, Integrated User Flow Blueprint V7.0

---

## a. Global Layout

### Mobile App (Sistem 1 — Multi-Role: Admin IT, Guru Mapel, Siswa)
- Navigasi atas menggunakan mekanisme horizontal linier tanpa sekat kaku, ditandai garis bawah aktif berwarna **#3182CE**.
- Segmented tabs mengikuti taksonomi IA: **Daily** (jadwal berjalan), **Payroll Schedule** (direpresentasikan sebagai Jadwal Mapel Jam ke-1 s.d Jam ke-X), dan **Monthly**.
- Sub-header tanggal berupa komponen kontrol penunjuk rentang waktu horizontal dilengkapi tombol panah kiri-kanan (contoh: `< Sun 10 - Sat 23 November 2025 >`).
- Satu codebase terpadu melayani tiga aktor lapangan secara dinamis berdasarkan validasi token JWT melalui API Gateway; tampilan menu menyesuaikan role pengguna yang login.

### Web Portal (Sistem 2 — Eksternal Pemantau: Orang Tua, Kepala Sekolah)
- Layout dashboard responsif desktop/tablet dengan sidebar/header yang menyesuaikan peran pengguna.
- Ditujukan eksklusif untuk fungsi monitoring non-pemindaian gawai (tanpa akses kamera/fitur lapangan).

---

## b. Route Map

### Mobile App Routes (Sistem 1)

| Route | Deskripsi | Status Akses |
|---|---|---|
| `/login` | Halaman login | Unauthenticated |
| `/dashboard-admin` | Dashboard Admin IT | Authenticated |
| `/kurikulum` | Manajemen Kurikulum & Kelas | Authenticated |
| `/hardware-binding` | Otorisasi Perangkat | Authenticated |
| `/unfreeze` | Manajemen Unfreeze Akun | Authenticated |
| `/dashboard-guru` | Dashboard Guru Mapel | Authenticated |
| `/scanner` | In-App Custom Scanner dengan Geofence | Authenticated |
| `/bypass` | Otorisasi Absen Manual Ter-Audit | Authenticated |
| `/dashboard-siswa` | Dashboard Siswa | Authenticated |
| `/barcode` | Penampil Barcode Dinamis dengan Anti-Screenshot | Authenticated |
| `/biometric` | Trigger Face Liveness Detection | Authenticated |

### Web Portal Routes (Sistem 2)

| Route | Deskripsi | Status Akses |
|---|---|---|
| `/login` | Halaman login | Unauthenticated |
| `/dashboard-orangtua` | Dashboard Orang Tua | Authenticated |
| `/monitoring` | Log Kehadiran Real-Time | Authenticated |
| `/izin` | Form Perizinan Digital | Authenticated |
| `/dashboard-kepsek` | Dashboard Kepala Sekolah (Read-Only) | Authenticated |
| `/analytics` | Grafik Indeks Keterlambatan & Distribusi Alpa | Authenticated |
| `/export` | Export Excel untuk Dapodik | Authenticated |

---

## c. Navigasi (Hierarki Menu per Role)

### 1. Admin IT / Tim IT Sekolah (Mobile)
- **Dashboard Utama Admin IT**
  - Status Sinkronisasi API Gateway & JWT Session Logs
  - Widget Log Keamanan Sistem Terkini
- **Manajemen Kurikulum & Kelas** (`/kurikulum`)
  - Form Entri Data Master Kurikulum (Tahun Ajaran, Semester)
  - Manajemen Alokasi Jam Pelajaran (Jam ke-1 s.d Jam ke-X)
  - Manajemen Daftar Ruang Kelas Fisik
  - Form Pemetaan Penugasan Guru Mapel ke Kelas
- **Keamanan & Proteksi Perangkat** (`/hardware-binding`, `/unfreeze`)
  - Otorisasi Hardware Binding Perdana (UUID/IMEI)
  - Form Reset Hardware Binding
  - Log Pendeteksi Status Freeze State
  - Fitur Eksekusi "Unfreeze Akun"

### 2. Guru Mata Pelajaran (Mobile)
- **Dashboard Utama Guru Mapel** (`/dashboard-guru`)
  - Informasi Jadwal Mengajar Aktif Hari Ini
  - Status Geofencing Batas Wilayah Sekolah
- **Modul Presensi Kelas Terpilih** (`/scanner`)
  - In-App Custom Scanner (Closed-Loop Handshake)
  - Geofence Validator Module (Validasi GPS, Log Blokir Kamera)
  - Offline Standby Buffer System (Indikator Koneksi, Cache Lokal, Log Sinkronisasi)
- **Otorisasi Absen Manual Ter-Audit** (`/bypass`)
  - Daftar Nama Kelas Digital
  - Form Modifikasi Status Kehadiran (Hadir, Izin, Sakit, Alfa)
  - Form Log Kendala Teknis & Alasan Bypass
  - Metadata Otomatis Koordinat GPS

### 3. Siswa/Murid (Mobile)
- **Dashboard Utama Siswa** (`/dashboard-siswa`)
  - Status Profil Terikat Perangkat (Hardware Binding)
  - Informasi Mata Pelajaran Berjalan
- **Modul Protokol Barcode Eksklusif** (`/barcode`)
  - Halaman Penampil Barcode Dinamis
  - Engine Enkripsi AES-256-CBC & Tanda Tangan HMAC-SHA256
  - Timer Refresh Asinkron (30 detik)
  - Komponen Native Anti-Screenshot/Recording
- **Otentikasi Biometrik Sekunder** (`/biometric`)
  - Listener Sinyal Asinkron Backend
  - Face Recognition Engine & Liveness Detection
  - Counter Gagal Verifikasi Terintegrasi

### 4. Orang Tua/Wali Murid (Web)
- **Dashboard Wali Murid** (`/dashboard-orangtua`)
  - Profil Anak Terkait
  - Ringkasan Kehadiran Anak Hari Ini
- **Pemantauan Aktivitas Real-Time** (`/monitoring`)
  - Log Jejak Kehadiran Harian per Jam Pelajaran
  - Riwayat Timestamp Presensi
  - Status Kehadiran per Mapel
  - Parameter Keterlambatan Kumulatif
- **Form Perizinan Kehadiran** (`/izin`)
  - Form Pengajuan Izin/Sakit Terstruktur (rentang tanggal, jenis izin, deskripsi)
  - Komponen Unggah Lampiran Dokumen (PDF/Gambar)

### 5. Kepala Sekolah/Manajemen (Web)
- **Dashboard Executive** (`/dashboard-kepsek`)
  - Status Operasional Sekolah Aktual
- **Modul Super-View Kendali Informasi** (Read Only Total)
  - Sub-View Data Binding Perangkat Seluruh Siswa
  - Sub-View Log Performa Presensi Kelas & Jadwal Aktif
  - Sub-View Riwayat Log Unfreeze Akun
- **Modul Analitik Grafik Akademik** (`/analytics`)
  - Visualisasi Grafik Indeks Keterlambatan Kumulatif
  - Visualisasi Grafik Akumulasi Siswa Alpa per Semester
- **Modul Pelaporan Eksternal** (`/export`)
  - Engine Pengekstrak Laporan Rekapitulasi (Bulanan & Semesteran)
  - Fitur Export ke Microsoft Excel (.xlsx)
  - Pipeline Integrasi Sinkronisasi Data Dapodik

---

## Aturan Pokok Hubungan Data Inter-Aktor

1. **Siklus Identitas Data**: Satu Jam Pelajaran = Satu Presensi. Tidak ada lagi data presensi harian terpusat. Jumlah siklus presensi dalam sehari mengikuti jumlah mata pelajaran yang dijadwalkan Admin IT.
2. **Ketergantungan Variabel `terlambatmenit`**: Dihitung otomatis di backend saat Guru berhasil memindai barcode siswa, berdasarkan selisih waktu sukses pemindaian terhadap data master jam mulai pelajaran yang diinput Admin IT. Data ini menjadi dasar informasi utama bagi sistem pemantauan Orang Tua dan visualisasi grafik Kepala Sekolah.
