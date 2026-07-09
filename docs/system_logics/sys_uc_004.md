# SYS-UC-004: Logika Audit Trail Bypass Manual Guru

**User Flow Terkait:** `userflow_uc_004.md`

## Input
- ID siswa yang dipilih Guru dari daftar kelas digital.
- Dispensasi status (Hadir/Izin/Sakit/Alfa) dan deskripsi alasan.
- Koordinat GPS gawai Guru saat submit.
- UUID gawai Guru.

## Proses / Algoritma
1. Sistem menerima request bypass manual dari sesi Guru yang telah tervalidasi JWT (SYS-UC-001).
2. Sistem memvalidasi kelengkapan field wajib: status dispensasi + deskripsi alasan.
3. Sistem menyuntikkan metadata audit secara otomatis dan tidak dapat diedit oleh Guru:
   - Koordinat GPS poligon sekolah saat submit.
   - Tanda tangan UUID gawai Guru.
   - Timestamp submit.
4. Sistem menulis record presensi dengan status `Waiting for Approval` (`#805AD5`) — **bukan** langsung berstatus final (Hadir/Izin/Sakit/Alfa).
5. Record beserta metadata audit disimpan dalam antrean verifikasi Admin IT.

## Output
- Record presensi berstatus `Waiting for Approval` beserta metadata audit lengkap (GPS, UUID, deskripsi, timestamp).

## Aturan Validasi / Error Handling
- Jika field deskripsi kosong → request ditolak, tidak ada record yang dibuat.
- Jika koordinat GPS gagal diambil → request ditolak (metadata audit wajib lengkap).
- Record berstatus `Waiting for Approval` **dilarang keras** ikut dihitung/dirender pada agregasi analitik (lihat SYS-UC-006) sebelum melalui proses verifikasi resmi Admin IT.

## Dependensi
- SYS-UC-001 (sesi JWT Guru harus valid).
- SYS-UC-006 (record ini menjadi kandidat data yang difilter pada lapisan agregasi hingga diverifikasi Admin IT).
