# SOFTWARE REQUIREMENTS SPECIFICATION (SRS)
## Sistem Presensi Kehadiran Siswa Berbasis Kelas (Zero-Trust Attendance Protocol)
**Institusi:** SMA Muhammadiyah Kasihan
**Sumber Acuan:** SRS V2, IA V2.1, Design System V5, Integrated User Flow Blueprint V7.0, Technical Specification Face Biometrics & Liveness Detection V2.0

---

## a. Tujuan Sistem

Sistem ini dibangun untuk mengganti mekanisme presensi harian terpusat (presensi gerbang/pagi) yang selama ini rentan terhadap kecurangan titip absen dan tidak mampu merekam kehadiran siswa secara akurat per mata pelajaran. Sistem wajib mengubah unit presensi menjadi berbasis Jam Pelajaran, di mana satu Jam Pelajaran menghasilkan satu siklus presensi, sehingga jumlah siklus presensi dalam sehari mengikuti jumlah mata pelajaran yang dijadwalkan oleh Admin IT.

Solusinya adalah "Zero-Trust Attendance Protocol", sebuah ekosistem dua platform (Mobile App untuk aktor lapangan dan Web Portal untuk aktor pemantau) yang memvalidasi kehadiran siswa melalui rangkaian mekanisme anti-fraud berlapis: barcode dinamis terenkripsi AES-256-CBC dengan tanda tangan HMAC-SHA256, hardware binding UUID/IMEI, geofencing lokasi guru, dan Face Liveness Detection sebagai faktor otentikasi kedua (2FA). Setiap perpindahan peran dan akses data dikendalikan oleh token JWT yang divalidasi ulang oleh API Gateway pada setiap request, sehingga akses lintas modul dilarang keras dan otomatis memicu pemutusan sesi.

---

## b. Aktor Pengguna

### SISTEM 1 (Multi-Role Mobile Application — Android/iOS)
Satu codebase terpadu dengan gerbang antarmuka dinamis berdasarkan token JWT:

1. **Admin IT Sekolah** — Modul mobilitas lapangan untuk konfigurasi kurikulum, hardware binding, dan unfreeze akun.
2. **Guru Mata Pelajaran** — Modul validasi kelas: pemindaian barcode, geofence, dan otorisasi absen manual ter-audit.
3. **Siswa/Murid** — Modul generator token presensi: barcode dinamis dan face liveness detection.

### SISTEM 2 (Centralized Web Application Portal)
Portal berbasis web responsif eksklusif untuk aktor pemantau eksternal tanpa fungsi pemindaian gawai:

4. **Orang Tua/Wali Murid** — Modul monitoring domestik: pemantauan real-time dan pengajuan izin/sakit digital.
5. **Kepala Sekolah/Manajemen** — Modul super-view kendali: akses Read-Only Total, analitik grafik, dan ekspor laporan Dapodik.

---

## c. Tech Stack

Dokumen referensi (SRS V2, IA V2.1, Design System V5, User Flow Blueprint V7.0, Technical Spec Biometrik V2.0) **tidak secara eksplisit menetapkan** framework/bahasa pemrograman spesifik untuk frontend atau backend. Yang dimandatkan secara eksplisit oleh dokumen sumber hanyalah sebagai berikut:

| Komponen | Ketentuan Wajib (Bersumber dari Dokumen) |
|---|---|
| Autentikasi | JWT (JSON Web Token) dengan validasi ulang oleh API Gateway pada setiap request (SRS-ARCH-001, SRS-ARCH-002, SRS-ARCH-003) |
| Otorisasi | Role-Based Access Control (RBAC) ketat pada level backend dan frontend |
| Enkripsi Barcode | AES-256-CBC untuk payload (Timestamp Epoch, DeviceID Siswa, GeoHash Location) |
| Tanda Tangan Digital | HMAC-SHA256 untuk validasi keaslian payload barcode |
| Push Notification | Firebase Cloud Messaging (FCM) — High-Priority Push Notification, wajib tuntas ≤ 1 detik |
| Proteksi Layar Native | `FLAG_SECURE` (Android) / Screen Recording Protection API (iOS) |
| Platform Mobile | Android 9 (Pie) atau lebih tinggi, iOS 13 atau lebih tinggi (SRS-NFR-003) |
| Spesifikasi Minimum Gawai | RAM ≥ 3 GB, kamera depan resolusi minimal 5 Megapiksel dengan kompensasi eksposur otomatis |
| Format Ekspor Laporan | Microsoft Excel (.xlsx) untuk integrasi Dapodik |

Untuk pilihan framework/bahasa aplikasi (Frontend Mobile, Frontend Web, Backend, Database), tim pengembang **wajib** memilih teknologi apa pun yang mampu memenuhi seluruh ketentuan wajib di atas secara utuh, karena dokumen sumber tidak mencantumkan preferensi vendor/framework tertentu. Keputusan ini didokumentasikan terpisah pada tahap technical design dan tidak dianggap sebagai bagian dari Source of Truth fungsional, sebagai upaya menjaga integritas SoT agar tidak menambahkan asumsi di luar referensi.

---

## d. In-Scope Features

1. **Autentikasi JWT dengan RBAC dinamis** — Pengarahan otomatis ke dashboard eksklusif sesuai role setelah verifikasi token; akses lintas modul memicu pembatalan sesi (SRS-ARCH-001–003).
2. **Manajemen Kurikulum & Kelas (Admin IT)** — Entri data master kurikulum, alokasi jam pelajaran, daftar ruang kelas fisik, dan pemetaan penugasan Guru Mapel ke kelas (SRS-FR-ADM-001).
3. **Hardware Binding (UUID/IMEI)** — Otorisasi pendaftaran perangkat perdana siswa dan proses reset hardware binding atas persetujuan Admin IT (SRS-FR-ADM-002).
4. **Barcode Generator Siswa (AES-256-CBC + HMAC)** — Barcode dinamis anti-screenshot yang menyegarkan diri setiap 30 detik (SRS-FR-SWS-001).
5. **In-App Scanner Guru dengan Geofence** — Modul kamera pemindai tertutup yang hanya aktif dalam radius toleransi ≤ 100 meter dari sekolah (SRS-FR-MAPEL-001, SRS-FR-MAPEL-002).
6. **Face Liveness Detection (2FA)** — Verifikasi wajah kedua berbasis 68-Facial Landmarks dan Eye Aspect Ratio (EAR), dipicu otomatis via FCM ≤ 1 detik pasca-scan guru (SRS-FR-SWS-002, SRS-FR-SWS-003, SRS-NFR-003).
7. **Freeze State & Unfreeze Akun** — Pembekuan otomatis gawai siswa setelah 3 kali gagal biometrik berturut-turut, dan pemulihan manual oleh Admin IT (SRS-FR-ADM-003).
8. **Otorisasi Absen Manual Ter-Audit (Bypass Guru)** — Perubahan status kehadiran manual dengan pencatatan otomatis koordinat GPS dan UUID gawai guru (SRS-FR-MAPEL-003).
9. **Dashboard Orang Tua (Donut Chart)** — Grafik lingkaran persentase kehadiran kumulatif dengan label "Today's Attendance Percentage" (SRS-FR-ORT-001).
10. **Form Perizinan Digital Orang Tua** — Pengajuan izin/sakit terstruktur dengan lampiran dokumen PDF/gambar (SRS-FR-ORT-002).
11. **Dashboard Kepala Sekolah (Grafik Analitik)** — Grafik Batang Indeks Keterlambatan dan Grafik Distribusi Alpa antar-kelas, dengan akses Read-Only Total (SRS-FR-KS-001, SRS-FR-KS-002).
12. **Export Excel untuk Dapodik** — Ekstraksi laporan rekapitulasi bulanan/semesteran ke format .xlsx untuk sinkronisasi Dapodik (SRS-FR-KS-003).
13. **Offline Standby Buffer** — Penyimpanan cache lokal terenkripsi pada gawai Guru saat jaringan sekolah terputus, dengan sinkronisasi otomatis pasca-koneksi pulih (SRS-NFR-004).

---

## e. Out-of-Scope Features

Berdasarkan pergeseran arsitektur dari sistem presensi lama ke Zero-Trust Attendance Protocol, hal-hal berikut **dilarang keras** menjadi bagian dari pengembangan:

1. **Tidak ada presensi gerbang/pagi terpusat** — Presensi harian di gerbang sekolah ditiadakan sepenuhnya; seluruh presensi wajib berbasis jam pelajaran (SRS-FR-CORE-001).
2. **Tidak ada remote unfreeze** — Pemulihan akun siswa yang membeku dilarang keras dilakukan dari jarak jauh; wajib melalui verifikasi fisik gawai oleh Admin IT (SRS-FR-ADM-003, Klausul 4.3 Technical Spec Biometrik V2.0).
3. **Tidak ada pemicuan biometrik atas inisiasi sepihak siswa** — Siklus Face Liveness Detection dilarang keras dipicu dari sisi gawai siswa; wajib dikontrol penuh oleh backend melalui closed-loop handshake.
4. **Tidak ada penarikan data belum terverifikasi ke dashboard analitik** — Data berstatus "Waiting for Approval" (#805AD5) atau "Offline Mode" (#A0AEC0) dilarang keras masuk ke komponen analitik Dashboard Orang Tua maupun Kepala Sekolah sebelum diverifikasi/dipulihkan Admin IT.
5. **Tidak ada pemindaian pihak ketiga** — Pemindaian barcode presensi menggunakan Google Lens atau aplikasi kamera pihak ketiga di luar ekosistem hanya menghasilkan string acak yang tidak tereksekusi (bukan fitur yang didukung).

> Catatan: Dokumen sumber tidak menyebutkan fitur forgot password maupun integrasi payment gateway sama sekali (baik sebagai in-scope maupun disebut eksplisit sebagai out-of-scope). Karena sistem ini adalah sistem presensi tanpa modul transaksi finansial, kedua fitur tersebut secara logis berada di luar cakupan fungsional yang didefinisikan oleh dokumen sumber.

---

## f. Business Rules

- **SRS-FR-CORE-001**: Satu Jam Pelajaran = Satu Presensi. Presensi siswa dialihkan sepenuhnya menjadi berbasis Jam Pelajaran (Per Mata Pelajaran); tidak ada lagi presensi gerbang/pagi terpusat.
- **SRS-FR-CORE-002**: Presensi hanya dilakukan 1 (satu) kali pada setiap jam pelajaran dimulai. Jika dalam 1 hari operasional terdapat 3 Mata Pelajaran berbeda, siswa wajib melakukan siklus presensi sebanyak 3 kali secara mandiri bersama Guru Mapel yang bersangkutan.
- **SRS-ARCH-001**: Sistem wajib mengimplementasikan RBAC yang ketat pada level arsitektur backend dan frontend di kedua platform.
- **SRS-ARCH-002**: Pengguna diarahkan secara dinamis menuju dashboard eksklusif role-nya setelah token JWT berhasil diverifikasi. Akses lintas modul role dilarang keras dan otomatis memicu pembatalan sesi.
- **SRS-ARCH-003**: Klaim hak akses role di dalam token JWT divalidasi ulang oleh API Gateway pada setiap request siklus presensi, pemindaian wajah, maupun mutasi database konfigurasi kelas.
- **SRS-FR-MAPEL-002**: Kamera pemindai Guru hanya dapat aktif jika koordinat GPS gawai tervalidasi berada dalam Geofence sekolah (radius toleransi ≤ 100 meter). Jika di luar radius, akses kamera diblokir.
- **SRS-FR-SWS-003 / Freeze State**: Jika verifikasi Face Liveness Detection gagal 3 kali berturut-turut (Count_fail ≥ 3), sistem wajib mengunci gawai siswa secara permanen di tempat (Freeze State = TRUE); token barcode dihapus dari memory buffer.
- **SRS-NFR-004 (Offline Standby Buffer)**: Jika jaringan sekolah terputus saat KBM, aplikasi Guru wajib menampilkan lencana "Offline Mode" (#A0AEC0) dan menyimpan data scan terenkripsi pada cache lokal sebelum sinkronisasi otomatis pasca-koneksi pulih.
- **Variabel `terlambatmenit`**: Dihitung otomatis di sisi backend berdasarkan selisih waktu sukses pemindaian barcode terhadap data master jam mulai pelajaran yang diinput Admin IT. Variabel ini menjadi dasar informasi utama bagi Dashboard Orang Tua dan grafik analitik Kepala Sekolah.
- **Batas Keamanan Kamera Native**: Halaman barcode siswa wajib mengunci `FLAG_SECURE` (Android) / Screen Recording Protection API (iOS); layar otomatis pekat/hitam jika terdeteksi usaha perekaman atau tangkapan layar.
- **Siklus Refresh Barcode**: Barcode wajib menyegarkan diri secara asinkron dari memory buffer gawai setiap 30 detik untuk mencegah distribusi kode ke luar kelas.
- **SRS-FR-ADM-003 / Pemulihan Fisik**: Pemulihan gawai terkunci wajib dilakukan melalui verifikasi fisik langsung oleh Admin IT pasca-KBM; remote unfreeze dilarang keras.
- **KLAUSUL INTEGRITAS DATA (Mutlak)**: Data berstatus "Waiting for Approval" (#805AD5) atau "Offline Mode" (#A0AEC0) **tidak boleh** masuk, dihitung, atau dirender ke dalam Dashboard Orang Tua maupun Kepala Sekolah sebelum diverifikasi dan diberi persetujuan resmi oleh Admin IT. Aturan ini ditegakkan mutlak untuk menjaga akurasi data sebelum disinkronkan ke Dapodik nasional.
- **Konkurensi**: Infrastruktur server wajib mampu merespons beban puncak hingga 500 pemindaian paralel dalam jendela waktu 5 menit awal jam pelajaran baru tanpa penurunan performa (SRS-NFR-002).
- **Ketersediaan Sistem**: Backend wajib menjamin uptime minimal 99.5% selama masa KBM (07.00–16.00 WIB) (SRS-NFR-001).
