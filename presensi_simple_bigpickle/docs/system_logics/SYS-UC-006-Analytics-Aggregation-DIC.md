# SYS-UC-006: Analytics Aggregation with Data Integrity Clause

## Data Integrity Clause (DIC) — Mandatory Filter
**Every aggregation query** for Orang Tua and Kepala Sekolah dashboards MUST exclude:
1. Records with `status === "Waiting for Approval"`
2. Records with `status_verifikasi === "Menunggu Verifikasi Admin IT"`
3. Records from "Offline Mode / Belum Sinkron" (OfflineBuffer.status_sinkron !== "Tersinkron")

## Orang Tua Dashboard
- `apiGetParentDashboard(orangtuaId)` → returns attendance summary of verified records only
- `apiGetMonitoring(orangtuaId)` → returns `AttendanceRecord[]` where `status_verifikasi === "Terverifikasi"`

## Kepala Sekolah Dashboard
- `apiGetKepsekDashboard()` → returns school-wide summary from verified records
- `apiGetAnalyticsLatency()` → latency index per mapel, verified records only
- `apiGetAnalyticsAlpa()` → alpa distribution, verified records only
- `apiExportExcel(periode)` → export of verified records only

## Non-compliance Risk
Records with `status_verifikasi !== "Terverifikasi"` on parent/kepsek dashboards would undermine trust in the attendance system by showing unverified/floating data as final. The DIC prevents this.
