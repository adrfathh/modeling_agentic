"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

interface NavItem {
  label: string;
  href: string;
  icon: string;
}

interface SidebarProps {
  role: "parent" | "principal";
  userName: string;
  userRole: string;
}

const parentNav: NavItem[] = [
  { label: "Dashboard", href: "/parent/dashboard", icon: "📊" },
  { label: "Rekap Kehadiran", href: "/parent/attendance", icon: "📋" },
  { label: "Notifikasi", href: "/parent/notifications", icon: "🔔" },
];

const principalNav: NavItem[] = [
  { label: "Dashboard", href: "/principal/dashboard", icon: "📊" },
  { label: "Rekap Sekolah", href: "/principal/school-report", icon: "🏫" },
  { label: "Per Kelas", href: "/principal/class-report", icon: "📋" },
  { label: "Siswa Bermasalah", href: "/principal/alerts", icon: "⚠️" },
];

export default function Sidebar({ role, userName, userRole }: SidebarProps) {
  const pathname = usePathname();
  const navItems = role === "parent" ? parentNav : principalNav;

  return (
    <aside className="sidebar">
      <div className="sidebar-brand">
        <div className="sidebar-brand-icon">🔒</div>
        <div className="sidebar-brand-text">
          <div className="sidebar-brand-title">SMA Muh. Kasihan</div>
          <div className="sidebar-brand-subtitle">Attendance Portal</div>
        </div>
      </div>

      <nav className="sidebar-nav">
        <div className="sidebar-section-label">Menu</div>
        {navItems.map((item) => (
          <Link
            key={item.href}
            href={item.href}
            className={`sidebar-link ${pathname === item.href ? "active" : ""}`}
          >
            <span className="sidebar-link-icon">{item.icon}</span>
            {item.label}
          </Link>
        ))}
      </nav>

      <div className="sidebar-footer">
        <div className="sidebar-user">
          <div className="sidebar-avatar">{userName[0]}</div>
          <div className="sidebar-user-info">
            <div className="sidebar-user-name">{userName}</div>
            <div className="sidebar-user-role">{userRole}</div>
          </div>
        </div>
      </div>
    </aside>
  );
}
