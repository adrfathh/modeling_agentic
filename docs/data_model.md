# DATA MODEL
## Sistem Presensi Kehadiran Siswa Berbasis Kelas (Zero-Trust Attendance Protocol)
**Institusi:** SMA Muhammadiyah Kasihan

> Dokumen ini mendefinisikan entitas data dan relasinya berdasarkan kebutuhan fungsional yang tercantum pada `srs.md`, `information_architecture.md`, dan `system_logics/`. Tipe data teknis (VARCHAR, INT, dsb.) tidak dispesifikasikan secara eksplisit oleh dokumen sumber; entitas dan atribut di bawah ini didefinisikan pada level konseptual sesuai kebutuhan fungsional.

## 1. Daftar Entitas

### 1.1 User
Representasi akun pengguna lintas role.
| Atribut | Deskripsi |
|---|---|
| user_id | Identifier unik pengguna |
| nama | Nama lengkap pengguna |
| role | Salah satu dari: Admin IT, Guru Mapel, Siswa, Orang Tua, Kepala Sekolah |
| username/email | Kredensial login |
| password_hash | Kredensial login (terenkripsi) |
| status_akun | Aktif / Freeze (khusus role Siswa) |

### 1.2 Device (Hardware Binding)
Mengikat identitas gawai fisik ke akun Siswa.
| Atribut | Deskripsi |
|---|---|
| device_id | UUID/IMEI gawai |
| user_id (FK) | Relasi ke Siswa pemilik gawai |
| status_binding | Terikat / Reset Pending |
| tanggal_binding | Tanggal otorisasi binding perdana oleh Admin IT |

### 1.3 Kurikulum & Kelas
| Entitas | Atribut Kunci |
|---|---|
| TahunAjaran | tahun_ajaran_id, semester |
| Kelas | kelas_id, nama_kelas, ruang_fisik |
| MataPelajaran | mapel_id, nama_mapel |
| PenugasanGuru | guru_id (FK User), mapel_id (FK), kelas_id (FK) |
| JadwalPelajaran (Jam ke-X) | jadwal_id, kelas_id (FK), mapel_id (FK), guru_id (FK), jam_ke, jam_mulai, jam_selesai |

### 1.4 BarcodeToken
Token dinamis presensi siswa.
| Atribut | Deskripsi |
|---|---|
| token_id | Identifier token |
| siswa_id (FK) | Relasi ke Siswa |
| payload_encrypted | Hasil AES-256-CBC(Timestamp_Epoch \|\| DeviceID_Siswa \|\| GeoHash_Location) |
| hmac_signature | Hasil HMAC_SHA256(payload, K_Private_Secret) |
| waktu_generate | Timestamp pembuatan token |
| siklus_refresh | 30 detik |

### 1.5 AttendanceRecord (Presensi)
Entitas inti — satu baris per Jam Pelajaran per Siswa.
| Atribut | Deskripsi |
|---|---|
| presensi_id | Identifier unik |
| siswa_id (FK) | Relasi ke Siswa |
| jadwal_id (FK) | Relasi ke JadwalPelajaran (Jam ke-X) |
| status | Hadir / Terlambat / Izin / Sakit / Alfa / Waiting for Approval |
| terlambatmenit | Selisih waktu scan sukses terhadap jam mulai pelajaran master |
| sumber_data | Scan Barcode+Biometrik / Bypass Manual Guru |
| waktu_presensi | Timestamp sukses presensi |
| status_verifikasi | Terverifikasi / Menunggu Verifikasi Admin IT (khusus data hasil bypass/offline) |

### 1.6 BiometricAttempt
Log percobaan verifikasi Face Liveness Detection.
| Atribut | Deskripsi |
|---|---|
| attempt_id | Identifier percobaan |
| siswa_id (FK) | Relasi ke Siswa |
| presensi_id (FK) | Relasi ke AttendanceRecord terkait |
| ear_value | Nilai Eye Aspect Ratio hasil kalkulasi |
| challenge_response_result | Sukses/Gagal |
| hasil_akhir | Sukses / Gagal |
| timestamp | Waktu percobaan |

### 1.7 FreezeState
Status pembekuan akun siswa.
| Atribut | Deskripsi |
|---|---|
| freeze_id | Identifier |
| siswa_id (FK) | Relasi ke Siswa |
| count_fail | Jumlah kegagalan biometrik berturut-turut |
| status_freeze | TRUE/FALSE |
| waktu_freeze | Timestamp saat Freeze State terpicu |
| waktu_unfreeze | Timestamp saat berhasil di-unfreeze |
| admin_id (FK) | Admin IT yang mengeksekusi unfreeze |

### 1.8 BypassLog (Otorisasi Absen Manual)
| Atribut | Deskripsi |
|---|---|
| bypass_id | Identifier |
| guru_id (FK) | Guru yang melakukan bypass |
| siswa_id (FK) | Siswa target |
| presensi_id (FK) | Relasi ke AttendanceRecord berstatus "Waiting for Approval" |
| status_dispensasi | Hadir/Izin/Sakit/Alfa |
| deskripsi_alasan | Log kendala teknis lapangan |
| koordinat_gps | Koordinat GPS Guru saat submit |
| uuid_gawai_guru | Tanda tangan UUID gawai Guru |
| status_persetujuan | Waiting for Approval / Approved / Rejected |
| admin_verifikator_id (FK) | Admin IT yang memverifikasi |

### 1.9 LeaveRequest (Izin/Sakit)
| Atribut | Deskripsi |
|---|---|
| izin_id | Identifier |
| siswa_id (FK) | Siswa terkait |
| orangtua_id (FK) | Orang tua pengaju |
| tanggal_mulai / tanggal_selesai | Rentang tanggal izin |
| jenis_izin | Izin/Sakit |
| deskripsi_alasan | Deskripsi |
| lampiran_dokumen | File PDF/Gambar |

### 1.10 OfflineBuffer
Cache lokal gawai Guru saat jaringan terputus.
| Atribut | Deskripsi |
|---|---|
| buffer_id | Identifier |
| guru_id (FK) | Guru pemilik cache |
| payload_encrypted | Data scan terenkripsi tersimpan lokal |
| status_sinkronisasi | Belum Sinkron / Tersinkron |
| waktu_sinkron | Timestamp sinkronisasi ke server |

### 1.11 AuditLog
Log umum aktivitas sensitif lintas modul (login, unfreeze, bypass, mutasi konfigurasi).
| Atribut | Deskripsi |
|---|---|
| log_id | Identifier |
| user_id (FK) | Pengguna pelaku aksi |
| jenis_aksi | Login / Unfreeze / Bypass / Mutasi Kurikulum, dst. |
| timestamp | Waktu aksi |
| detail | Metadata tambahan (GPS, UUID, dsb.) |

---

## 2. Relasi Antar-Entitas (Ringkasan)

- **User (Siswa)** 1—1 **Device** (satu akun siswa terikat satu gawai aktif).
- **User (Siswa)** 1—N **BarcodeToken** (token disegarkan berkala).
- **JadwalPelajaran** 1—N **AttendanceRecord** (satu jadwal jam pelajaran dapat memiliki banyak record presensi siswa berbeda).
- **AttendanceRecord** 1—1 **BiometricAttempt** (per siklus scan, satu percobaan biometrik terkait — dapat lebih dari satu jika terjadi retry sebelum Freeze).
- **AttendanceRecord** 1—0..1 **BypassLog** (hanya ada jika presensi dihasilkan dari jalur bypass manual, bukan scan normal).
- **User (Siswa)** 1—N **FreezeState** (riwayat freeze/unfreeze dari waktu ke waktu).
- **User (Orang Tua)** N—N **User (Siswa)** melalui relasi wali (satu orang tua dapat memiliki lebih dari satu anak terdaftar).
- **User (Guru)** 1—N **OfflineBuffer** (cache lokal per sesi mengajar saat offline).

## 3. Klausul Integritas Data (Berlaku pada Level Model)

Field `status_verifikasi` pada `AttendanceRecord` dan `status_persetujuan` pada `BypassLog` **wajib** dijadikan filter mutlak pada setiap query agregasi menuju Dashboard Orang Tua dan Kepala Sekolah. Record dengan status `Waiting for Approval` atau `Offline Mode/Belum Sinkron` tidak boleh diikutsertakan dalam hasil agregasi sampai status berubah menjadi `Terverifikasi/Approved`.
