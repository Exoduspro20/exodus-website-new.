# EXODUS — Vercel website + LMS starter

## Preserved website
All original HTML pages and assets are copied unchanged into `public/`, except:
- Homepage adds a small fixed **Student / Instructor Login** link.
- Original `ontario-security-guard-course.html` loads `lms-bridge.js` (no redesign).

## Deployment
1. Unzip and push the **project root** (containing `package.json`, `app/`, `public/`) to GitHub.
2. Import GitHub repository in Vercel; framework **Next.js**. Do **not** upload only `public/`.
3. Create Supabase project; run `supabase/schema.sql` in SQL Editor.
4. Set environment variables in Vercel (see `.env.example`). **Never put service role key in client code or GitHub**.
5. Configure Supabase Auth URL / redirect allowlist for Vercel domain and custom domain, email verification, SMTP, and anti-abuse controls.
6. Create instructor accounts normally, then manually assign role in Supabase SQL (see schema comment).
7. Test registration, private ID upload, instructor permissions, and records before allowing real users.
8. Point your domain DNS to Vercel per Vercel project instructions; preserve MX/TXT records for email.

## URLs
- `/index.html` — existing homepage; `/` redirects to it
- `/ontario-security-guard-course.html` — existing course UI
- `/portal` — student sign-up/login, ID upload and records
- `/portal/instructor` — instructor status dashboard

## Important limitations: NOT production-ready / NOT a completed compliance LMS
- The original course still stores timer, quiz and activity results in browser localStorage. The bridge synchronizes **unverified snapshots**; they are editable and must not count as verified instructional time, completion, quiz results or proof of identity. No server-enforced lesson progression yet.
- Current HTML course is publicly fetchable as a static asset even though bridge redirects users who are not signed in. **Access control is not secure** until moved behind authenticated server-side delivery.
- Instructor can manually approve completion statuses; this is **not** an automatic eligibility or certificate issuing system. There is **no PDF certificate generator, certificate verification, Ministry completion-number integration, payment checkout or secure ID document review viewer** yet.
- No production retention/deletion policies, audit hardening, rate limits, malware scanning, backups, privacy review or verification of Ontario training provider requirements.
- Verify Ontario legal, curriculum, course hour, identity, accessibility, first aid, instructor availability and reporting requirements before using this for actual licensing training.
- CDN dependency in bridge should be replaced with bundled JS for production. Supabase auth tokens stored in browser are subject to XSS risks; harden before production.

## Recommended next implementation phase
1. Migrate existing course event handlers to authenticated, server-enforced per-module progress, quizzes, games, and time tracking.
2. Protect course delivery at the server layer and enforce enrollment/identity verification.
3. Add instructor ID review via time-limited signed URLs, retention controls and audit logs.
4. Add first aid verification, approval workflow, PDF certificates with verification IDs and reporting.
5. Security/privacy/compliance testing before onboarding real students.

## Instructor dashboard upgrade
- `/portal/instructor` now lists students, ID submissions, unverified progress snapshots, and manual verification checklists.
- Instructor/admin roles can request a **60-second signed link** to a private ID submission. These links should not be copied or shared. Storage remains private.
- Completion approval is blocked until ID is approved and four manual verification checkboxes are checked: hours, assessments, first aid/CPR, and provider requirements.
- Instructor decisions and document access attempts are logged in `audit_log` (check database logs for any audit insertion errors).
- Instructor notes are retained in `student_verifications`; avoid including unnecessary sensitive personal information.
- **IMPORTANT:** Run the updated `supabase/schema.sql` in Supabase SQL Editor to add `student_verifications` before deploying this version. Existing tables are preserved. If old policies already exist, the original `create policy` statements can report duplicates on rerun; execute only the new `student_verifications` section when upgrading an existing database.
- This is still **not** an accredited/compliance-certified LMS. It does not provide server-verified attendance, course time, assessment results, automated certificates, document malware scanning, retention policies or secure course delivery. Do not approve real completions based on browser snapshots.
