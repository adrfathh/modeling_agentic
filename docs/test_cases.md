# TEST CASES
## Sistem Presensi Kehadiran Siswa Berbasis Kelas (Zero-Trust Attendance Protocol)
**Institusi:** SMA Muhammadiyah Kasihan

> Setiap Test Case ID mengacu pada Business Rule/Requirement ID di `srs.md` dan logika terkait di `system_logics/`.

## Modul: Autentikasi & RBAC (Ref: SYS-UC-001)

| TC ID | Deskripsi | Pre-condition | Langkah Pengujian | Expected Result | Prioritas |
|---|---|---|---|---|---|
| TC-001 | Login sukses dengan kredensial valid | Akun terdaftar | Input kredensial valid → submit | Token JWT diterbitkan, routing ke dashboard sesuai role | Tinggi |
| TC-002 | Login gagal dengan kredensial salah | Akun terdaftar | Input password salah → submit | Login ditolak, tidak ada token diterbitkan | Tinggi |
| TC-003 | Akses lintas modul role diblokir | User Guru login | Guru mencoba akses endpoint `/dashboard-admin` | Request ditolak, sesi otomatis terminasi (SRS-ARCH-002) | Kritikal |

## Modul: Barcode & Scan (Ref: SYS-UC-002)

| TC ID | Deskripsi | Pre-condition | Langkah Pengujian | Expected Result | Prioritas |
|---|---|---|---|---|---|
| TC-004 | Refresh barcode otomatis 30 detik | Siswa membuka halaman barcode | Tunggu 30 detik, amati payload | Payload berubah, token lama tidak valid lagi | Tinggi |
| TC-005 | Kamera Guru diblokir di luar Geofence | Guru berada > 100 meter dari sekolah | Guru membuka menu scanner | Kamera tidak aktif, pesan error blokir tampil | Kritikal |
| TC-006 | Kamera Guru aktif dalam radius Geofence | Guru berada ≤ 100 meter dari sekolah | Guru membuka menu scanner | Kamera aktif normal | Tinggi |
| TC-007 | Validasi HMAC gagal ditolak | Payload dimanipulasi/signature tidak cocok | Guru scan barcode termanipulasi | Sistem menolak payload, tidak membuat record presensi | Kritikal |
| TC-008 | Kalkulasi `terlambatmenit` akurat | Jadwal jam mulai = 07.00, scan sukses 07.10 | Guru scan barcode siswa pukul 07.10 | `terlambatmenit` = 10, status "Terlambat" (#ECC94B) | Tinggi |
| TC-009 | Pemindaian via aplikasi kamera pihak ketiga gagal | Google Lens/kamera eksternal digunakan | Scan barcode siswa dengan aplikasi luar ekosistem | Hanya menghasilkan string acak, tidak ada record presensi dibuat | Sedang |

## Modul: Offline Standby Buffer (Ref: SRS-NFR-004)

| TC ID | Deskripsi | Pre-condition | Langkah Pengujian | Expected Result | Prioritas |
|---|---|---|---|---|---|
| TC-010 | Data tersimpan lokal saat jaringan terputus | Simulasikan jaringan sekolah terputus | Guru melakukan scan barcode | Lencana "Offline Mode" (#A0AEC0) tampil, data tersimpan di cache lokal | Tinggi |
| TC-011 | Sinkronisasi otomatis pasca-koneksi pulih | Data tersimpan di cache lokal (TC-010) | Pulihkan koneksi jaringan | Data tersinkron otomatis ke server tanpa aksi manual | Tinggi |

## Modul: Face Liveness Detection (Ref: SYS-UC-003)

| TC ID | Deskripsi | Pre-condition | Langkah Pengujian | Expected Result | Prioritas |
|---|---|---|---|---|---|
| TC-012 | Trigger kamera depan otomatis pasca-scan | Scan barcode Guru sukses | Amati gawai siswa | Kamera depan aktif otomatis ≤ 1 detik tanpa ketukan manual | Kritikal |
| TC-013 | Anti-screenshot aktif saat kamera biometrik terbuka | Kamera depan aktif | Coba screenshot/rekam layar | Layar terblokir/pekat, capture gagal | Kritikal |
| TC-014 | Verifikasi biometrik sukses | Siswa melakukan kedipan valid + challenge-response dalam waktu | Amati status presensi | Status berubah menjadi Hadir/Terlambat sesuai `terlambatmenit` | Tinggi |
| TC-015 | Freeze State terpicu pada kegagalan ke-3 | Siswa gagal verifikasi 2 kali berturut-turut | Siswa gagal verifikasi ke-3 | Freeze State = TRUE, layar bermutasi ungu penuh (#805AD5), token dihapus | Kritikal |
| TC-016 | Biometrik tidak dapat dipicu sepihak dari klien | Tidak ada sinyal trigger dari backend | Siswa mencoba membuka modul biometrik secara manual | Sistem menolak, modul tidak aktif tanpa closed-loop handshake backend | Kritikal |

## Modul: Bypass Manual Guru (Ref: SYS-UC-004)

| TC ID | Deskripsi | Pre-condition | Langkah Pengujian | Expected Result | Prioritas |
|---|---|---|---|---|---|
| TC-017 | Bypass tanpa deskripsi alasan ditolak | Guru membuka form bypass | Submit tanpa mengisi deskripsi | Form ditolak, request tidak tersimpan | Sedang |
| TC-018 | Metadata audit tercatat otomatis | Guru submit bypass valid | Amati record presensi hasil bypass | GPS, UUID gawai Guru, dan timestamp tercatat otomatis | Tinggi |
| TC-019 | Status bypass masuk "Waiting for Approval" | Guru submit bypass valid | Amati status presensi | Status = Waiting for Approval (#805AD5) | Tinggi |

## Modul: Freeze & Unfreeze (Ref: SYS-UC-005)

| TC ID | Deskripsi | Pre-condition | Langkah Pengujian | Expected Result | Prioritas |
|---|---|---|---|---|---|
| TC-020 | Remote unfreeze ditolak sistem | Gawai siswa dalam Freeze State | Coba eksekusi unfreeze tanpa verifikasi fisik/dari jarak jauh | Sistem menolak proses unfreeze | Kritikal |
| TC-021 | Unfreeze sukses oleh Admin IT | Admin IT memverifikasi fisik gawai | Admin IT eksekusi "Unfreeze Akun" | Count_fail = 0, status barcode kembali normal | Tinggi |

## Modul: Dashboard & Klausul Integritas Data (Ref: SYS-UC-006)

| TC ID | Deskripsi | Pre-condition | Langkah Pengujian | Expected Result | Prioritas |
|---|---|---|---|---|---|
| TC-022 | Data "Waiting for Approval" tidak muncul di dashboard | Ada record berstatus Waiting for Approval | Orang tua membuka Donut Chart | Data tersebut tidak dihitung dalam persentase kehadiran | Kritikal |
| TC-023 | Data "Offline Mode" belum sinkron tidak muncul di dashboard | Ada record belum tersinkron | Kepala Sekolah membuka grafik analitik | Data tersebut tidak dihitung dalam grafik | Kritikal |
| TC-024 | Data muncul setelah diverifikasi Admin IT | Record bypass telah disetujui Admin IT | Refresh Dashboard Orang Tua/Kepala Sekolah | Data kini terhitung dalam agregasi | Tinggi |
| TC-025 | Kepala Sekolah tidak dapat mutasi data (Read-Only) | Kepala Sekolah login | Coba akses fitur edit/hapus data presensi | Aksi ditolak, hanya tampilan Read-Only tersedia | Tinggi |
| TC-026 | Export .xlsx berhasil dan sesuai format | Data periode berjalan tersedia | Kepala Sekolah eksekusi export | File .xlsx terunduh dengan data final terverifikasi saja | Tinggi |

## Modul: Non-Functional

| TC ID | Deskripsi | Pre-condition | Langkah Pengujian | Expected Result | Prioritas |
|---|---|---|---|---|---|
| TC-027 | Uptime backend selama jam KBM | Monitoring aktif 07.00–16.00 WIB | Pantau selama periode KBM | Uptime ≥ 99.5% (SRS-NFR-001) | Sedang |
| TC-028 | Beban 500 scan paralel | Simulasi load testing | Kirim 500 request scan dalam 5 menit | Tidak ada penurunan performa signifikan (SRS-NFR-002) | Tinggi |
