# UC-006: Monitoring / Analytics / Export Dapodik

**Actors:** Orang Tua (monitoring), Kepala Sekolah (analytics, export)

## Orang Tua — Monitoring
**Main Flow:**
1. Parent opens Dashboard → donut chart with attendance percentage
2. Parent opens Monitoring → vertical timeline of child's attendance records
3. Parent opens Izin → form to submit leave request
4. **All data filtered by Data Integrity Clause:**
   - `status_verifikasi !== "Menunggu Verifikasi Admin IT"`
   - `status !== "Waiting for Approval"`
   - "Offline Mode / Belum Sinkron" records excluded

## Kepala Sekolah — Analytics
**Main Flow:**
1. Kepsek opens Dashboard → summary cards (kehadiran %, terlambat count, alpa count)
2. Kepsek opens Analytics → Indeks Keterlambatan bar chart + Alpa distribution chart
3. **Data Integrity Clause enforced on all aggregations**

## Kepala Sekolah — Export
**Main Flow:**
1. Kepsek selects period (Mingguan/Bulanan/Semester)
2. System generates Excel (.xlsx) with columns:
   - Nama Siswa | Kelas | Mapel | Status | Jam | Tanggal | Keterangan
3. **Waiting for Approval and Offline Mode records excluded**

**Business Rules:**
- Data Integrity Clause is NON-NEGOTIABLE — no aggregation query may include non-final statuses
- Kepala Sekolah view is read-only — no edit/delete actions
