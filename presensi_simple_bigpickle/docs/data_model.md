# Data Model — Sistem Presensi Kehadiran Siswa

## Entities

### User
| Field | Type | Description |
|-------|------|-------------|
| user_id | PK:int | Unique ID |
| nama | string | Full name |
| username | string | Login username |
| password | string | Hashed password |
| role | enum: admin_it, guru, siswa, orang_tua, kepala_sekolah | RBAC role |
| status_akun | enum: Aktif, Freeze | Account status |
| device_bound | bool | Whether device is bound |
| device_id | FK:string|null | Bound device ID |
| kelas | string|null | Siswa class (e.g. "X-A") |
| anak | array|null | Orang tua's children (user_id, nama, kelas) |

### Device
| Field | Type | Description |
|-------|------|-------------|
| device_id | PK:string | Unique device identifier |
| user_id | FK:int | Owner user |
| status_binding | enum: Terikat, Reset Pending | Binding status |
| tanggal_binding | date | Date of binding |

### TahunAjaran / Kelas / MataPelajaran / PenugasanGuru / JadwalPelajaran
| Field | Type | Description |
|-------|------|-------------|
| jadwal_id | PK:int | Unique ID |
| kelas_id | int | Class identifier |
| mapel | string | Subject name |
| guru_nama | string | Assigned teacher |
| jam_ke | int | Period number (1..X) |
| jam_mulai | string | HH:mm start time |
| jam_selesai | string | HH:mm end time |
| ruang | string | Room name |

### BarcodeToken
| Field | Type | Description |
|-------|------|-------------|
| encrypted | string | AES-256-CBC encrypted payload |
| hmac | string | HMAC-SHA256 signature |
| timestamp | epoch | Generation timestamp |
| expires_at | epoch | Expiry (30s after generation) |
| device_id | string | Source device bound ID |
| koordinat_gps | string | Lat,lng of generation |

### AttendanceRecord
| Field | Type | Description |
|-------|------|-------------|
| presensi_id | PK:int | Unique ID |
| siswa_id | FK:int | Attending student |
| siswa_nama | string | Student name |
| jadwal_id | FK:int | Schedule slot |
| mapel | string | Subject |
| jam_ke | int | Period number |
| status | enum: Hadir, Terlambat, Izin, Sakit, Alfa, Waiting for Approval | Attendance status |
| terlambatmenit | int | Minutes late (0 if on time) |
| sumber_data | enum: Scan Barcode+Biometrik, Bypass Manual Guru | Origin |
| waktu_presensi | datetime | Recorded time |
| status_verifikasi | enum: Terverifikasi, Menunggu Verifikasi Admin IT | Verification status |

### BiometricAttempt
| Field | Type | Description |
|-------|------|-------------|
| attempt_id | PK:int | Unique ID |
| siswa_id | FK:int | Attempting student |
| presensi_id | FK:int | Linked presensi |
| ear_value | decimal | Computed EAR (0.0-0.5) |
| challenge_response_result | enum: Sukses, Gagal | Liveness check |
| hasil_akhir | enum: Sukses, Gagal | Final result |
| timestamp | datetime | Attempt time |

### FreezeState
| Field | Type | Description |
|-------|------|-------------|
| freeze_id | PK:int | Unique ID |
| siswa_id | FK:int | Frozen student |
| siswa_nama | string | Student name |
| count_fail | int | Failure counter (≥3 = freeze) |
| status_freeze | bool | Currently frozen |
| waktu_freeze | datetime | When freeze triggered |
| waktu_unfreeze | datetime|null | When unfrozen (null if still frozen) |

### BypassLog
| Field | Type | Description |
|-------|------|-------------|
| bypass_id | PK:int | Unique ID |
| guru_id | FK:int | Issuing teacher |
| guru_nama | string | Teacher name |
| siswa_id | FK:int | Target student |
| siswa_nama | string | Student name |
| presensi_id | FK:int | Linked presensi |
| status_dispensasi | string | Granted status |
| deskripsi_alasan | string | Mandatory reason |
| koordinat_gps | string | Guru GPS at time of bypass |
| uuid_gawai_guru | string | Guru device UUID |
| status_persetujuan | enum: Waiting for Approval, Approved, Rejected | Approval status |

### LeaveRequest
| Field | Type | Description |
|-------|------|-------------|
| izin_id | PK:int | Unique ID |
| siswa_id | FK:int | Student on leave |
| siswa_nama | string | Student name |
| orangtua_id | FK:int | Submitting parent |
| tanggal_mulai | date | Leave start |
| tanggal_selesai | date | Leave end |
| jenis_izin | enum: Izin, Sakit | Leave type |
| deskripsi_alasan | string | Reason |
| lampiran_dokumen | string|null | Attachment URL |
| status | enum: Pending, Disetujui, Ditolak | Approval status |

### OfflineBuffer
| Field | Type | Description |
|-------|------|-------------|
| buffer_id | PK:int | Unique ID |
| siswa_id | FK:int | Student |
| payload | string | Cached attendance data |
| status_sinkron | enum: Belum Sinkron, Tersinkron | Sync status |
| dibuat_pada | datetime | Creation time |

### AuditLog
| Field | Type | Description |
|-------|------|-------------|
| log_id | PK:int | Unique ID |
| user_id | FK:int | Acting user |
| jenis_aksi | string | Action type |
| timestamp | datetime | Action time |
| detail | string | Description |

## Relations
- User.siswa → Device.user_id (one-to-one for binding)
- User.siswa → FreezeState.siswa_id (one-to-one for freeze)
- User.guru → BypassLog.guru_id (one-to-many)
- JadwalPelajaran → AttendanceRecord.jadwal_id (one-to-many)
- AttendanceRecord → BiometricAttempt.presensi_id (one-to-one)
- User.orang_tua.anak[] → User.siswa.user_id (parent-child)
- AttendanceRecord.status_verifikasi = "Menunggu Verifikasi Admin IT" is NOT final — excluded from parent/kepsek dashboards (Data Integrity Clause)
