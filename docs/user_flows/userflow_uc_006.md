# UC-006: Monitoring, Analitik & Export Dapodik

**Aktor:** Orang Tua/Wali Murid, Kepala Sekolah

## Pre-condition
- Orang Tua/Kepala Sekolah sudah login dan terautentikasi via token JWT (lihat UC-001).
- Data presensi anak/kelas telah tersinkronisasi ke database pusat dari alur lapangan (UC-002 s.d UC-005).

## Main Flow

### A. Alur Orang Tua/Wali Murid (Monitoring Domestik)
1. Orang tua login di peramban web desktop/tablet dan diarahkan ke `/dashboard-orangtua`.
2. Sistem membaca relasi entitas anak, lalu merender kartu visual **Donut Chart Metrik Persentase** — teks numerik tebal besar (contoh: `95%`) dengan sub-judul "Today's Attendance Percentage".
3. Orang tua membuka `/monitoring` untuk melihat Log Jejak Kehadiran Harian per jam pelajaran, riwayat timestamp presensi, status kehadiran per mapel, dan parameter `terlambatmenit` kumulatif.
4. Jika diperlukan, orang tua membuka `/izin` untuk mengajukan Form Perizinan Digital (rentang tanggal, jenis izin, deskripsi alasan, unggah lampiran PDF/gambar).

### B. Alur Kepala Sekolah (Super-View Kendali)
5. Kepala Sekolah login di peramban web dan diarahkan ke `/dashboard-kepsek` dengan hak akses **Read-Only Total**.
6. Kepala Sekolah membuka `/analytics` untuk melihat:
   - **Grafik Batang Indeks Keterlambatan** — mengurutkan ranking siswa berdasarkan `terlambatmenit` kumulatif tertinggi.
   - **Grafik Distribusi Alpa** — visualisasi komparatif ketidakhadiran antar-kelas.
7. Kepala Sekolah membuka `/export` untuk mengekstrak laporan rekapitulasi kehadiran (bulanan/semesteran) ke format Microsoft Excel (.xlsx) sebagai penyuplai data sinkronisasi Dapodik nasional.

## Alternative/Exception Flow
- **Klausul Integritas Data (Mutlak)**: Data berstatus "Waiting for Approval" (`#805AD5`, hasil bypass Guru pada UC-004) atau "Offline Mode" (`#A0AEC0`, hasil cache lokal Guru pada UC-002) **dilarang keras** ditarik masuk, dihitung, atau dirender ke dalam Donut Chart Orang Tua maupun Grafik Analitik Kepala Sekolah sebelum diverifikasi dan disetujui resmi oleh Admin IT.
- **Jika orang tua mengunggah lampiran izin dengan format selain PDF/Gambar**: Sistem menolak unggahan dan meminta format ulang.
- **Jika Kepala Sekolah mencoba melakukan aksi mutasi data (bukan Read-Only)**: Dilarang keras; hak akses Kepala Sekolah terbatas pada Read-Only Total (SRS-FR-KS-001).

## Post-condition
Orang tua memperoleh gambaran transparan kehadiran anak secara real-time dan dapat mengajukan izin/sakit digital. Kepala Sekolah memperoleh visualisasi analitik performa presensi sekolah dan file laporan .xlsx siap disinkronkan ke Dapodik nasional, dengan jaminan bahwa seluruh data yang ditampilkan telah melalui proses verifikasi Admin IT.
