# SYS-UC-001: JWT/RBAC Validation

**Scope:** Every API endpoint except login

**Logic:**
1. Client sends `Authorization: Bearer <token>` header
2. Server decodes JWT → extracts `{user_id, role, exp}`
3. If expired (`exp < NOW`) → 401 Unauthorized
4. If role doesn't match endpoint permission → 403 Forbidden
5. If valid → attach user context to request

**Mock Implementation (client-side):**
- `api.ts` functions check token from auth context
- `getRoleDashboard(role)` maps role to redirect path
- Layout useEffect calls `apiGetMe(token)` on mount to re-validate
- Role gating in layout: if user role doesn't match route group → redirect `/login`
