"use client";

import KpiCard from "@/components/KpiCard";
import DonutChart from "@/components/DonutChart";
import StatusChip from "@/components/StatusChip";

const classData = [
  { kelas: "X IPA 1", guru: "Bpk. Ari", hadir: 30, total: 32, alpa: 1, terlambat: 1 },
  { kelas: "X IPA 2", guru: "Ibu Siti", hadir: 28, total: 30, alpa: 2, terlambat: 0 },
  { kelas: "XI IPA 1", guru: "Bpk. Hendro", hadir: 31, total: 32, alpa: 0, terlambat: 1 },
  { kelas: "XI IPA 2", guru: "Ibu Ratna", hadir: 29, total: 32, alpa: 2, terlambat: 1 },
  { kelas: "XI IPS 1", guru: "Bpk. Dimas", hadir: 27, total: 30, alpa: 3, terlambat: 0 },
  { kelas: "XII IPA 1", guru: "Ibu Wati", hadir: 32, total: 33, alpa: 0, terlambat: 1 },
  { kelas: "XII IPS 1", guru: "Bpk. Joko", hadir: 25, total: 28, alpa: 2, terlambat: 1 },
];

const alertStudents = [
  { name: "Hendra Kurniawan", kelas: "X IPA 1", issue: "Frozen — 3x gagal biometrik", status: "alpa" as const },
  { name: "Indah Lestari", kelas: "XI IPS 2", issue: "5 hari alpa berturut-turut", status: "alpa" as const },
  { name: "Joko Mulyono", kelas: "XII IPA 3", issue: "Frozen — perangkat tidak dikenali", status: "waiting" as const },
];

export default function PrincipalDashboard() {
  const totalSiswa = classData.reduce((s, c) => s + c.total, 0);
  const totalHadir = classData.reduce((s, c) => s + c.hadir, 0);
  const totalAlpa = classData.reduce((s, c) => s + c.alpa, 0);
  const totalTerlambat = classData.reduce((s, c) => s + c.terlambat, 0);

  return (
    <>
      <div style={{ marginBottom: "24px" }}>
        <h1 className="text-h1">Dashboard Sekolah</h1>
        <p className="text-body">
          {new Date().toLocaleDateString("id-ID", { weekday: "long", year: "numeric", month: "long", day: "numeric" })}
        </p>
      </div>

      {/* Alert Banner */}
      {alertStudents.length > 0 && (
        <div className="alert alert--danger" style={{ marginBottom: "24px" }}>
          ⚠️ {alertStudents.length} siswa memerlukan perhatian — Lihat detail di menu &quot;Siswa Bermasalah&quot;
        </div>
      )}

      {/* KPI Grid */}
      <div className="kpi-grid">
        <KpiCard value={totalSiswa} label="Total Siswa" variant="primary" />
        <KpiCard value={totalHadir} label="Hadir Hari Ini" variant="hadir" delta={{ value: `${Math.round(totalHadir/totalSiswa*100)}%`, direction: "up" }} />
        <KpiCard value={totalAlpa} label="Alpa" variant="alpa" delta={{ value: `${totalAlpa} siswa`, direction: "down" }} />
        <KpiCard value={totalTerlambat} label="Terlambat" variant="terlambat" />
      </div>

      {/* Content Grid */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "24px", marginTop: "8px" }}>
        {/* Donut */}
        <div className="card">
          <div className="card-header">
            <h3 className="text-title">Ringkasan Kehadiran</h3>
            <span className="text-caption">Seluruh sekolah hari ini</span>
          </div>
          <DonutChart hadir={totalHadir} terlambat={totalTerlambat} alpa={totalAlpa} />
          <p className="text-micro" style={{ textAlign: "center", marginTop: "12px" }}>
            Data menunggu verifikasi tidak dihitung
          </p>
        </div>

        {/* Class Ranking */}
        <div className="card">
          <div className="card-header">
            <h3 className="text-title">Kehadiran Per Kelas</h3>
          </div>
          <table className="data-table">
            <thead>
              <tr>
                <th>Kelas</th>
                <th>Wali</th>
                <th>Hadir</th>
                <th>Alpa</th>
                <th>%</th>
              </tr>
            </thead>
            <tbody>
              {classData.map((c) => {
                const pct = Math.round((c.hadir / c.total) * 100);
                return (
                  <tr key={c.kelas}>
                    <td className="text-body-bold">{c.kelas}</td>
                    <td className="text-caption">{c.guru}</td>
                    <td>
                      <span style={{ color: "var(--color-hadir)", fontWeight: 600 }}>{c.hadir}</span>
                      <span className="text-caption">/{c.total}</span>
                    </td>
                    <td>
                      {c.alpa > 0 ? (
                        <span style={{ color: "var(--color-alpa)", fontWeight: 600 }}>{c.alpa}</span>
                      ) : (
                        <span className="text-caption">0</span>
                      )}
                    </td>
                    <td>
                      <div style={{
                        width: "100%",
                        height: 6,
                        background: "var(--divider)",
                        borderRadius: 3,
                        overflow: "hidden"
                      }}>
                        <div style={{
                          width: `${pct}%`,
                          height: "100%",
                          background: pct >= 95 ? "var(--color-hadir)" : pct >= 80 ? "var(--color-terlambat)" : "var(--color-alpa)",
                          borderRadius: 3,
                          transition: "width 0.5s ease",
                        }} />
                      </div>
                      <span className="text-micro">{pct}%</span>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
}
