"use client";

import StatusChip from "@/components/StatusChip";

const weekData = [
  { date: "Senin, 23 Jun", entries: [
    { jam: 1, mapel: "B. Indonesia", status: "hadir" as const, time: "07.05" },
    { jam: 2, mapel: "Fisika", status: "hadir" as const, time: "08.00" },
    { jam: 3, mapel: "Matematika", status: "waiting" as const, time: "08.35" },
  ]},
  { date: "Jumat, 20 Jun", entries: [
    { jam: 1, mapel: "PKN", status: "terlambat" as const, time: "07.25" },
    { jam: 2, mapel: "Seni Budaya", status: "hadir" as const, time: "08.02" },
  ]},
  { date: "Kamis, 19 Jun", entries: [
    { jam: 1, mapel: "B. Indonesia", status: "hadir" as const, time: "06.55" },
    { jam: 2, mapel: "Fisika", status: "hadir" as const, time: "08.00" },
    { jam: 3, mapel: "Matematika", status: "alpa" as const, time: "-" },
  ]},
  { date: "Rabu, 18 Jun", entries: [
    { jam: 1, mapel: "PKN", status: "hadir" as const, time: "07.00" },
    { jam: 2, mapel: "Seni Budaya", status: "hadir" as const, time: "08.01" },
  ]},
];

export default function AttendancePage() {
  return (
    <>
      <div style={{ marginBottom: "24px", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <h1 className="text-h1">Rekap Kehadiran</h1>
        <div style={{ display: "flex", gap: "8px" }}>
          <button className="btn btn--outline btn--sm">← Minggu Lalu</button>
          <button className="btn btn--outline btn--sm">Minggu Depan →</button>
        </div>
      </div>

      {/* Summary Row */}
      <div className="kpi-grid" style={{ gridTemplateColumns: "repeat(4, 1fr)", marginBottom: "24px" }}>
        <div className="card" style={{ padding: "16px", display: "flex", alignItems: "center", gap: "12px" }}>
          <span className="status-dot status-dot--hadir" style={{ width: 12, height: 12 }} />
          <div>
            <div className="text-h2" style={{ color: "var(--color-hadir)" }}>18</div>
            <div className="text-caption">Hadir</div>
          </div>
        </div>
        <div className="card" style={{ padding: "16px", display: "flex", alignItems: "center", gap: "12px" }}>
          <span className="status-dot status-dot--terlambat" style={{ width: 12, height: 12 }} />
          <div>
            <div className="text-h2" style={{ color: "var(--color-terlambat)" }}>1</div>
            <div className="text-caption">Terlambat</div>
          </div>
        </div>
        <div className="card" style={{ padding: "16px", display: "flex", alignItems: "center", gap: "12px" }}>
          <span className="status-dot status-dot--alpa" style={{ width: 12, height: 12 }} />
          <div>
            <div className="text-h2" style={{ color: "var(--color-alpa)" }}>1</div>
            <div className="text-caption">Alpa</div>
          </div>
        </div>
        <div className="card" style={{ padding: "16px", display: "flex", alignItems: "center", gap: "12px" }}>
          <span className="status-dot status-dot--waiting" style={{ width: 12, height: 12 }} />
          <div>
            <div className="text-h2" style={{ color: "var(--color-waiting)" }}>1</div>
            <div className="text-caption">Menunggu</div>
          </div>
        </div>
      </div>

      {/* Week Detail */}
      {weekData.map((day) => (
        <div key={day.date} className="card" style={{ marginBottom: "12px" }}>
          <h4 className="text-body-bold" style={{ marginBottom: "12px" }}>{day.date}</h4>
          <table className="data-table">
            <thead>
              <tr>
                <th>Jam</th>
                <th>Mata Pelajaran</th>
                <th>Status</th>
                <th>Waktu Scan</th>
              </tr>
            </thead>
            <tbody>
              {day.entries.map((e) => (
                <tr key={`${day.date}-${e.jam}`}>
                  <td>Jam ke-{e.jam}</td>
                  <td>{e.mapel}</td>
                  <td><StatusChip status={e.status} /></td>
                  <td className="text-caption">{e.time} WIB</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ))}
    </>
  );
}
