"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

type Role = "ortu" | "kepsek";

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    await new Promise((r) => setTimeout(r, 800));
    setLoading(false);
  };

  const demoLogin = (role: Role) => {
    router.push(role === "ortu" ? "/parent/dashboard" : "/principal/dashboard");
  };

  return (
    <div className="login-page">
      <div className="login-card">
        <div className="login-logo">🔒</div>
        <h1 className="text-h1 login-title">SMA Muhammadiyah Kasihan</h1>
        <p className="login-subtitle">Zero-Trust Attendance — Web Portal</p>

        <form onSubmit={handleLogin}>
          <div className="form-group">
            <label className="form-label" htmlFor="email">
              Email
            </label>
            <input
              id="email"
              className="form-input"
              type="email"
              placeholder="Masukkan email Anda"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
          </div>
          <div className="form-group">
            <label className="form-label" htmlFor="password">
              Password
            </label>
            <input
              id="password"
              className="form-input"
              type="password"
              placeholder="Masukkan password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </div>
          <button className="login-btn" type="submit" disabled={loading}>
            {loading ? "Memproses..." : "Masuk"}
          </button>
        </form>

        <div className="login-divider">Demo Login</div>

        <div className="demo-roles">
          <button
            className="demo-role-btn"
            onClick={() => demoLogin("ortu")}
            style={{ borderColor: "var(--color-hadir)" }}
          >
            <span>👨‍👩‍👧</span>
            Orang Tua
          </button>
          <button
            className="demo-role-btn"
            onClick={() => demoLogin("kepsek")}
            style={{ borderColor: "var(--color-primary)" }}
          >
            <span>🏫</span>
            Kepala Sekolah
          </button>
        </div>
      </div>
    </div>
  );
}
