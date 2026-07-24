"use client";

import { useState } from "react";
import StatusChip from "@/components/StatusChip";
import DonutChart from "@/components/DonutChart";

const classes = ["X IPA 1", "X IPA 2", "XI IPA 1", "XI IPA 2", "XI IPS 1", "XII IPA 1", "XII IPS 1"];

const studentsMap: Record<string, Array<{ name: string; status: "hadir" | "alpa" | "terlambat" | "waiting"; time: string }>> = {
  "XI IPA 2": [
    { name: "Ahmad Rizky Pratama", status: "hadir", time: "07.05" },
    { name: "Budi Santoso", status: "hadir", time: "07.02" },
    { name: "Citra Dewi", status: "hadir", time: "06.58" },
    { name: "Dian Fitrianti", status: "terlambat", time: "07.25" },
    { name: "Eka Putri", status: "hadir", time: "07.00" },
    { name: "Fajar Aditya", status: "alpa", time: "-" },
    { name: "Gina Wulandari", status: "hadir", time: "06.55" },
    { name: "Hendra K.", status: "waiting", time: "08.35" },
  ],
};

export default function ClassReportPage() {
  const [selected, setSelected] = useState("XI IPA 2");
  const students = studentsMap[selected] || studentsMap["XI IPA 2"];
  const hadir = students.filter((s) => s.status === "hadir").length;
  const alpa = students.filter((s) => s.status === "alpa").length;
  const terlambat = students.filter((s) => s.status === "terlambat").length;

  return (
    <>
      <div style={{ marginBottom: "24px" }}>
        <h1 className="text-h1">Rekap Per Kelas</h1>
        <p className="text-body">Detail kehadiran per kelas hari ini</p>
      </div>

      {/* Class Selector */}
      <div style={{ display: "flex", gap: "8px", marginBottom: "24px", flexWrap: "wrap" }}>
        {classes.map((c) => (
          <button
            key={c}
            className={`btn ${c === selected ? "btn--primary" : "btn--outline"} btn--sm`}
            onClick={() => setSelected(c)}
          >
            {c}
          </button>
        ))}
      </div>

      <div style={{ display: "grid", gridTemplateColumns: "280px 1fr", gap: "24px" }}>
        {/* Donut */}
        <div className="card">
          <h3 className="text-title" style={{ marginBottom: "16px" }}>{selected}</h3>
          <DonutChart hadir={hadir} terlambat={terlambat} alpa={alpa} size={140} />
        </div>

        {/* Student List */}
        <div className="card">
          <div className="card-header">
            <h3 className="text-title">Daftar Siswa</h3>
            <span className="text-caption">{students.length} siswa</span>
          </div>
          <table className="data-table">
            <thead>
              <tr>
                <th>#</th>
                <th>Nama Siswa</th>
                <th>Status</th>
                <th>Waktu Scan</th>
              </tr>
            </thead>
            <tbody>
              {students.map((s, i) => (
                <tr key={s.name}>
                  <td className="text-caption">{i + 1}</td>
                  <td>
                    <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
                      <div
                        className="data-table-avatar"
                        style={{ background: s.status === "hadir" ? "var(--color-hadir)" : s.status === "alpa" ? "var(--color-alpa)" : "var(--color-waiting)" }}
                      >
                        {s.name[0]}
                      </div>
                      <span className="text-body-bold">{s.name}</span>
                    </div>
                  </td>
                  <td><StatusChip status={s.status} /></td>
                  <td className="text-caption">{s.time} {s.time !== "-" ? "WIB" : ""}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
}
