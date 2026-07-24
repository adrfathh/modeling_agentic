"use client";

import KpiCard from "@/components/KpiCard";
import DonutChart from "@/components/DonutChart";
import StatusChip from "@/components/StatusChip";

const todayEntries = [
  { jam: 1, mapel: "Bahasa Indonesia", status: "hadir" as const, time: "07.05 WIB", meta: "✓ Auto approved – 07.12 WIB" },
  { jam: 2, mapel: "Fisika", status: "hadir" as const, time: "08.00 WIB", meta: "✓ Auto approved – 08.05 WIB" },
  { jam: 3, mapel: "Matematika", status: "waiting" as const, time: "08.35 WIB", meta: "Menunggu persetujuan guru" },
];

export default function ParentDashboard() {
  return (
    <>
      {/* Welcome */}
      <div style={{ marginBottom: "24px" }}>
        <h1 className="text-h1">Selamat Datang, Ibu Ratna 👋</h1>
        <p className="text-body">Pantau kehadiran Ahmad Rizky Pratama — XI IPA 2</p>
      </div>

      {/* KPI Grid */}
      <div className="kpi-grid">
        <KpiCard value={2} label="Hadir Hari Ini" variant="hadir" delta={{ value: "+1 vs kemarin", direction: "up" }} />
        <KpiCard value={0} label="Alpa Hari Ini" variant="alpa" />
        <KpiCard value={1} label="Menunggu Verifikasi" variant="waiting" />
        <KpiCard value="93%" label="Kehadiran Bulan Ini" variant="primary" delta={{ value: "+2%", direction: "up" }} />
      </div>

      {/* Content Grid: Donut + Timeline */}
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1.5fr", gap: "24px" }}>
        {/* Donut Chart */}
        <div className="card">
          <div className="card-header">
            <h3 className="text-title">Statistik Kehadiran</h3>
            <span className="text-caption">Bulan ini</span>
          </div>
          <DonutChart hadir={22} terlambat={2} alpa={1} />
        </div>

        {/* Today Timeline */}
        <div className="card">
          <div className="card-header">
            <h3 className="text-title">Presensi Hari Ini</h3>
            <span className="text-caption">{new Date().toLocaleDateString("id-ID", { weekday: "long", year: "numeric", month: "long", day: "numeric" })}</span>
          </div>
          <table className="data-table">
            <thead>
              <tr>
                <th>Jam</th>
                <th>Mata Pelajaran</th>
                <th>Status</th>
                <th>Waktu</th>
                <th>Keterangan</th>
              </tr>
            </thead>
            <tbody>
              {todayEntries.map((e) => (
                <tr key={e.jam}>
                  <td className="text-body-bold">Jam ke-{e.jam}</td>
                  <td>{e.mapel}</td>
                  <td><StatusChip status={e.status} /></td>
                  <td className="text-caption">{e.time}</td>
                  <td className="text-caption">{e.meta}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Notifications */}
      <div className="card" style={{ marginTop: "24px" }}>
        <div className="card-header">
          <h3 className="text-title">Notifikasi Terbaru</h3>
        </div>
        <div style={{ display: "flex", flexDirection: "column", gap: "12px" }}>
          <div className="alert alert--info">
            📘 Jam ke-3 (Matematika) — Barcode telah dipindai, menunggu verifikasi guru
          </div>
          <div className="alert alert--success">
            ✅ Jam ke-2 (Fisika) — Ahmad Rizky tercatat hadir otomatis pukul 08.05 WIB
          </div>
          <div className="alert alert--success">
            ✅ Jam ke-1 (Bahasa Indonesia) — Ahmad Rizky tercatat hadir otomatis pukul 07.12 WIB
          </div>
        </div>
      </div>
    </>
  );
}
