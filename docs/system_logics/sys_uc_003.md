# SYS-UC-003: Algoritma Liveness Detection (EAR & Challenge-Response)

**User Flow Terkait:** `userflow_uc_003.md`

## Input
- Sinyal trigger FCM dari SYS-UC-002 (hasil scan barcode sukses).
- Stream kamera depan native gawai siswa.
- Spesifikasi hardware gawai (RAM, versi OS, resolusi kamera) untuk pre-check.

## Proses / Algoritma
1. **Pre-check Hardware (SRS-NFR-003)**: Modul biometrik hanya aktif jika gawai memenuhi: OS ≥ Android 9 (Pie) / iOS 13, RAM ≥ 3 GB, kamera depan ≥ 5 MP dengan kompensasi eksposur otomatis.
2. **Aktivasi Kamera Terkendali Backend**: Listener background menangkap trigger FCM (SLA ≤ 1 detik), memvalidasi sesi JWT internal, lalu mengaktifkan kamera depan tanpa interaksi manual siswa (closed-loop handshake — dilarang keras diinisiasi sepihak dari klien).
3. **Proteksi Native**: `FLAG_SECURE` (Android) / Screen Recording Protection API (iOS) disuntikkan ke jendela kamera sebelum proses capture dimulai.
4. **Ekstraksi Landmark**: Engine lokal memetakan wajah ke 68-Facial Landmarks.
5. **Kalkulasi EAR (Eye Aspect Ratio)**:
   `EAR = (|p₂ - p₆| + |p₃ - p₅|) / (2 × |p₁ - p₄|)`
   Kedipan valid terdeteksi jika `EAR ≤ 0.2` bertahan selama `0.15` detik.
6. **Challenge-Response Dinamis (paralel)**: Sistem menerbitkan instruksi acak (pergerakan pupil mengikuti titik sirkular virtual, atau penolehan kepala ±15°) dengan batas waktu 3 detik.
7. **Keputusan Otentikasi**: Sukses jika (a) kedipan valid terdeteksi **dan** (b) challenge-response terselesaikan dalam jendela waktu. Jika salah satu gagal → `Count_fail += 1`.
8. **Uji Kondisi Freeze**: `Count_fail ≥ 3` → `Freeze State = TRUE` (lihat SYS-UC-005 untuk logika pemulihan).

## Output
- Status otentikasi biometrik: sukses/gagal.
- Status presensi final: Hadir (`#48BB78`) atau Terlambat (`#ECC94B`), berdasarkan `terlambatmenit` dari SYS-UC-002.
- Counter `Count_fail` ter-update.

## Aturan Validasi / Error Handling
- Modul biometrik dilarang keras dipicu dari inisiasi sepihak gawai siswa (harus melalui closed-loop handshake backend).
- Jika kondisi cahaya menyebabkan wajah tidak teridentifikasi → dihitung sebagai kegagalan (menambah `Count_fail`).
- `Count_fail ≥ 3` memicu isolasi mandiri lokal: token barcode dihapus dari memory buffer, layar bermutasi penuh menjadi `#805AD5`.

## Dependensi
- SYS-UC-002 (prasyarat: hasil scan barcode valid dan sinyal FCM diterima).
- SYS-UC-005 (jalur lanjutan jika Freeze State terpicu).
