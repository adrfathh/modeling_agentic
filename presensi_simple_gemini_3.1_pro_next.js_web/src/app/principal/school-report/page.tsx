"use client";

import DonutChart from "@/components/DonutChart";

const monthData = [
  { month: "Januari", hadir: 6240, terlambat: 120, alpa: 95 },
  { month: "Februari", hadir: 5980, terlambat: 140, alpa: 110 },
  { month: "Maret", hadir: 6100, terlambat: 100, alpa: 88 },
  { month: "April", hadir: 6050, terlambat: 130, alpa: 92 },
  { month: "Mei", hadir: 6200, terlambat: 95, alpa: 75 },
  { month: "Juni", hadir: 3100, terlambat: 48, alpa: 40 },
];

export default function SchoolReportPage() {
  return (
    <>
      <div style={{ marginBottom: "24px" }}>
        <h1 className="text-h1">Rekap Kehadiran Sekolah</h1>
        <p className="text-body">Tahun Ajaran 2025/2026</p>
      </div>

      {/* Monthly Chart */}
      <div className="card" style={{ marginBottom: "24px" }}>
        <div className="card-header">
          <h3 className="text-title">Tren Kehadiran Bulanan</h3>
        </div>
        <div style={{ display: "flex", gap: "8px", alignItems: "flex-end", height: "200px", padding: "0 8px" }}>
          {monthData.map((m) => {
            const total = m.hadir + m.terlambat + m.alpa;
            const pct = Math.round((m.hadir / total) * 100);
            return (
              <div key={m.month} style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: "4px" }}>
                <span className="text-micro">{pct}%</span>
                <div style={{
                  width: "100%",
                  height: `${pct * 1.8}px`,
                  background: pct >= 95 ? "var(--color-hadir)" : pct >= 90 ? "var(--color-terlambat)" : "var(--color-alpa)",
                  borderRadius: "4px 4px 0 0",
                  transition: "height 0.5s ease",
                  opacity: 0.85,
                }} />
                <span className="text-micro">{m.month.substring(0, 3)}</span>
              </div>
            );
          })}
        </div>
      </div>

      {/* Monthly Details */}
      <div className="card">
        <div className="card-header">
          <h3 className="text-title">Detail Bulanan</h3>
        </div>
        <table className="data-table">
          <thead>
            <tr>
              <th>Bulan</th>
              <th>Total Hadir</th>
              <th>Terlambat</th>
              <th>Alpa</th>
              <th>Persentase</th>
            </tr>
          </thead>
          <tbody>
            {monthData.map((m) => {
              const total = m.hadir + m.terlambat + m.alpa;
              const pct = ((m.hadir / total) * 100).toFixed(1);
              return (
                <tr key={m.month}>
                  <td className="text-body-bold">{m.month}</td>
                  <td style={{ color: "var(--color-hadir)", fontWeight: 600 }}>{m.hadir.toLocaleString()}</td>
                  <td style={{ color: "var(--color-terlambat)", fontWeight: 600 }}>{m.terlambat}</td>
                  <td style={{ color: "var(--color-alpa)", fontWeight: 600 }}>{m.alpa}</td>
                  <td className="text-body-bold">{pct}%</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </>
  );
}
