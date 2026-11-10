-- Run ONCE in Supabase SQL Editor before using Red Cross registration.
-- These tables are server-only; no direct browser policies are granted.
create table if not exists public.red_cross_registrations (
 id uuid primary key default gen_random_uuid(), full_name text not null, email text not null,
 phone text not null, course text not null, preferred_date text not null default '',
 location text not null, notes text not null default '',
 status text not null default 'pending' check(status in ('pending','accepted','rejected','cancelled')),
 id_verified boolean not null default false, course_completed boolean not null default false,
 certificate_number text unique, certificate_issued_at timestamptz, certificate_issued_by uuid references public.profiles(id),
 created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 constraint red_cross_certificate_requirements check(certificate_issued_at is null or (status='accepted' and id_verified and course_completed and certificate_number is not null))
);
create table if not exists public.red_cross_audit (
 id bigint generated always as identity primary key,
 registration_id uuid references public.red_cross_registrations(id),
 actor_id uuid references public.profiles(id),action text not null,details jsonb,created_at timestamptz not null default now()
);
alter table public.red_cross_registrations enable row level security;
alter table public.red_cross_audit enable row level security;
revoke all on public.red_cross_registrations from anon,authenticated;
revoke all on public.red_cross_audit from anon,authenticated;
-- API endpoints use a server-only service role after checking instructor/admin access.
-- Do not treat these records as official Canadian Red Cross certificates.
