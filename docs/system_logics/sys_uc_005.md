# SYS-UC-005: Logika Reset Freeze State & Unfreeze Counter

**User Flow Terkait:** `userflow_uc_005.md`

## Input
- Sinyal `Freeze State = TRUE` dari SYS-UC-003 (Count_fail ≥ 3).
- Perintah eksekusi "Unfreeze Akun" dari sesi Admin IT tervalidasi JWT.

## Proses / Algoritma
1. **Pemicuan Freeze (otomatis, dari SYS-UC-003)**:
   `Count_fail ≥ 3 → Freeze State = TRUE`
   Sistem mengeksekusi isolasi mandiri lokal pada gawai siswa: modul penampil barcode dimatikan, generator token enkripsi dihapus dari memori volatil, layar bermutasi penuh menjadi `#805AD5`.
2. **Pencatatan Log Keamanan**: Sistem mencatat riwayat kegagalan biometrik ke widget Log Keamanan Sistem yang dapat diakses Admin IT.
3. **Verifikasi Manual oleh Admin IT**: Admin IT memeriksa log kegagalan dan mengonfirmasi integritas fisik gawai siswa (di luar kendali sistem — proses manual/fisik).
4. **Eksekusi Unfreeze**: Setelah Admin IT menekan perintah "Unfreeze Akun", sistem wajib:
   - Membersihkan memory buffer gawai siswa secara asinkron.
   - Mereset `Count_fail = 0`.
   - Mengembalikan status penampil barcode ke kondisi operasional normal.
5. Sistem mencatat log eksekusi unfreeze (siapa, kapan) untuk keperluan audit dan Sub-View Riwayat Log Unfreeze Kepala Sekolah.

## Output
- Status gawai siswa kembali normal, `Count_fail` = 0.
- Entry log unfreeze tercatat untuk audit trail.

## Aturan Validasi / Error Handling
- **Larangan Remote Unfreeze**: Sistem wajib menolak setiap request unfreeze yang tidak disertai proses verifikasi fisik gawai (SRS-FR-ADM-003). Tidak ada endpoint/mekanisme unfreeze jarak jauh yang diizinkan.
- Hanya role Admin IT yang memiliki hak eksekusi perintah "Unfreeze Akun" (RBAC — divalidasi via SYS-UC-001).

## Dependensi
- SYS-UC-003 (sumber pemicu Freeze State).
- SYS-UC-001 (validasi role Admin IT).
- SYS-UC-006 (log unfreeze tersedia sebagai Sub-View Read-Only bagi Kepala Sekolah).
