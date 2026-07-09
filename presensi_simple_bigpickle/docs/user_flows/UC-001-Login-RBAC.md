# UC-001: Login & RBAC Routing

**Actor:** All roles (admin_it, guru, siswa, orang_tua, kepala_sekolah)

**Main Flow:**
1. User enters username + password on `/login`
2. System validates credentials against User store
3. System generates JWT token with `{user_id, role, exp}`
4. System determines role-based redirect:
   - admin_it → `/dashboard-admin`
   - guru → `/dashboard-guru`
   - siswa → `/dashboard-siswa`
   - orang_tua → `/dashboard-orangtua`
   - kepala_sekolah → `/dashboard-kepsek`
5. JWT stored in localStorage
6. Layout reads JWT, calls `apiGetMe(token)` to validate
7. If invalid/expired → redirect `/login`

**Alternative Flow (Invalid Credentials):**
- Show error message on login form
- Stay on `/login`

**Exception Flow (Expired Token):**
- Layout detects 401 from `apiGetMe`
- Clears localStorage
- Redirects to `/login`
