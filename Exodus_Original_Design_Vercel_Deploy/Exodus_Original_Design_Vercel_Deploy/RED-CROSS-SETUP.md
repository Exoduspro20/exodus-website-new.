# EXODUS Red Cross registration update

1. Run `supabase/red-cross-migration.sql` in your existing Supabase project SQL Editor. Without this, registrations will fail with a visible error.
2. Preserve all existing Vercel environment variables. Never expose `SUPABASE_SERVICE_ROLE_KEY` to browser code.
3. Deploy the contents of this ZIP into the existing `Exodus_Vercel_LMS_Starter` repository directory, retaining folder paths.
4. Visit `/red-cross.html` to verify the Training Partner logo and submit a test registration. Review it at `/red-cross-instructor` after signing in at `/portal` with an instructor/admin account.
5. Verify ID documents using a secure, approved process. This update records the instructor's verification decision but does NOT implement a new secure ID-upload interface for Red Cross registrations.
6. The certificate action records an INTERNAL issuance reference, not an official Canadian Red Cross certificate. Use the approved Red Cross certification system for any official credential.
7. Course dates are still published through `public/training-dates.json`; the form accepts the chosen preferred date, and staff must manually accept enrolment. There is no automated seat-capacity enforcement.
8. Before production, implement rate limiting and anti-spam protections on the public registration endpoint, review privacy/retention policies and test all access controls. Avoid submitting real IDs until secure document handling has been reviewed.
