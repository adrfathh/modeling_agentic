import Sidebar from "@/components/Sidebar";
import Link from "next/link";

export default function PrincipalLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="app-layout">
      <Sidebar
        role="principal"
        userName="Bpk. Suparman, M.Pd."
        userRole="Kepala Sekolah"
      />
      <main className="main-content">
        <header className="content-header">
          <h2 className="text-title">Portal Kepala Sekolah</h2>
          <div style={{ display: "flex", alignItems: "center", gap: "12px" }}>
            <button className="btn btn--outline btn--sm">📅 Export Rekap</button>
            <Link href="/" className="btn btn--outline btn--sm">Logout</Link>
          </div>
        </header>
        <div className="content-body">{children}</div>
      </main>
    </div>
  );
}
