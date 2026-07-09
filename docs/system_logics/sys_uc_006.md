# SYS-UC-006: Logika Agregasi Data Analitik & Klausul Integritas Data

**User Flow Terkait:** `userflow_uc_006.md`

## Input
- Seluruh record presensi dari SYS-UC-002 (hasil scan valid), SYS-UC-003 (hasil biometrik), dan SYS-UC-004 (hasil bypass manual).
- Request render dashboard dari sesi Orang Tua/Kepala Sekolah tervalidasi JWT.
- Request export laporan dari sesi Kepala Sekolah.

## Proses / Algoritma
1. **Filtering Status (Data Integrity Gate)**: Sebelum data diagregasi ke endpoint dashboard, sistem wajib menyaring record berdasarkan status:
   - Record berstatus `Waiting for Approval` (`#805AD5`) → **dikecualikan**.
   - Record berstatus `Offline Mode` (`#A0AEC0`) yang belum tersinkronisasi/terverifikasi → **dikecualikan**.
   - Hanya record berstatus final terverifikasi (Hadir, Terlambat, Izin, Sakit, Alfa yang telah disetujui) yang diteruskan ke lapisan agregasi.
2. **Agregasi Donut Chart (Orang Tua)**: Sistem menghitung persentase kumulatif kehadiran anak dari record final, dirender sebagai teks numerik tebal (contoh `95%`) dengan label "Today's Attendance Percentage".
3. **Agregasi Grafik Batang Indeks Keterlambatan (Kepala Sekolah)**: Sistem mengurutkan siswa berdasarkan akumulasi `terlambatmenit` dari record final, tertinggi ke terendah.
4. **Agregasi Grafik Distribusi Alpa (Kepala Sekolah)**: Sistem menghitung jumlah record berstatus Alpa (`#E53E3E`) per kelas untuk perbandingan antar-kelas.
5. **Generasi Export Dapodio**: Sistem mengekstrak seluruh record final periode berjalan (bulanan/semesteran) ke format `.xlsx`, dipetakan ke skema kolom yang sesuai kebutuhan sinkronisasi Dapodik nasional.

## Output
- Payload Donut Chart (persentase kehadiran) untuk Dashboard Orang Tua.
- Payload grafik batang & grafik distribusi untuk Dashboard Kepala Sekolah.
- File `.xlsx` siap diunduh/disinkronkan ke Dapodik.

## Aturan Validasi / Error Handling
- **KLAUSUL INTEGRITAS MUTLAK**: Sistem dilarang keras merender atau menghitung data berstatus `Waiting for Approval` atau `Offline Mode` ke dalam komponen analitik apa pun sebelum diverifikasi/disetujui resmi oleh Admin IT. Pelanggaran klausul ini dianggap cacat integritas data.
- Akses Kepala Sekolah terbatas Read-Only Total — sistem menolak setiap request mutasi data dari role ini (SRS-FR-KS-001).
- Data anak yang ditampilkan ke Orang Tua wajib difilter berdasarkan relasi entitas anak-orang tua yang terdaftar (tidak boleh menampilkan data siswa lain).

## Dependensi
- SYS-UC-002, SYS-UC-003 (sumber data presensi hasil scan/biometrik).
- SYS-UC-004 (sumber data bypass yang wajib difilter hingga terverifikasi).
- SYS-UC-005 (log unfreeze yang ditampilkan pada Sub-View Kepala Sekolah).
