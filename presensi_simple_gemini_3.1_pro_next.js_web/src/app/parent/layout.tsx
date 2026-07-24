import Sidebar from "@/components/Sidebar";
import Link from "next/link";

export default function ParentLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="app-layout">
      <Sidebar
        role="parent"
        userName="Ibu Ratna Sari"
        userRole="Orang Tua — Ahmad Rizky (XI IPA 2)"
      />
      <main className="main-content">
        <header className="content-header">
          <h2 className="text-title">Portal Orang Tua</h2>
          <div style={{ display: "flex", alignItems: "center", gap: "12px" }}>
            <button className="btn btn--outline btn--sm">🔔 2</button>
            <Link href="/" className="btn btn--outline btn--sm">Logout</Link>
          </div>
        </header>
        <div className="content-body">{children}</div>
      </main>
    </div>
  );
}
