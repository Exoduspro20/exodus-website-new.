-- Run in Supabase SQL editor. Keep service role key server-side only.
create table if not exists public.profiles (id uuid primary key references auth.users(id) on delete cascade, full_name text, role text not null default 'student' check (role in ('student','instructor','admin')), id_status text not null default 'pending' check (id_status in ('pending','approved','rejected')), certificate_status text not null default 'not_approved' check (certificate_status in ('not_approved','approved','revoked')), created_at timestamptz not null default now());
create table if not exists public.progress_snapshots (student_id uuid primary key references public.profiles(id) on delete cascade, snapshot jsonb not null default '{}'::jsonb, updated_at timestamptz not null default now());
create table if not exists public.identity_submissions (id uuid primary key default gen_random_uuid(), student_id uuid not null references public.profiles(id) on delete cascade, storage_path text not null, created_at timestamptz not null default now());
create table if not exists public.audit_log (id bigint generated always as identity primary key, actor_id uuid references public.profiles(id), student_id uuid references public.profiles(id), action text not null, details jsonb, created_at timestamptz not null default now());
create or replace function public.create_student_profile() returns trigger language plpgsql security definer set search_path = '' as $$ begin insert into public.profiles(id,full_name) values (new.id,coalesce(new.raw_user_meta_data->>'full_name','')); return new; end $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.create_student_profile();
alter table public.profiles enable row level security;
alter table public.progress_snapshots enable row level security;
alter table public.identity_submissions enable row level security;
alter table public.audit_log enable row level security;
create policy "read own profile" on public.profiles for select to authenticated using (auth.uid()=id);
create policy "read own snapshots" on public.progress_snapshots for select to authenticated using (auth.uid()=student_id);
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types) values ('identity-documents','identity-documents',false,5242880,array['application/pdf','image/jpeg','image/png']) on conflict(id) do update set public=false,file_size_limit=5242880,allowed_mime_types=array['application/pdf','image/jpeg','image/png'];
-- Assign instructor role manually in Supabase SQL after confirming identity:
-- update public.profiles set role='instructor' where id='AUTH_USER_UUID';

-- Instructor verification checklist. These are MANUAL confirmations of independently reviewed records,
-- NOT automatically verified course hours or quiz outcomes.
create table if not exists public.student_verifications (
 student_id uuid primary key references public.profiles(id) on delete cascade,
 hours_verified boolean not null default false,
 assessment_verified boolean not null default false,
 first_aid_verified boolean not null default false,
 provider_requirements_verified boolean not null default false,
 notes text not null default '',
 reviewed_by uuid references public.profiles(id),
 reviewed_at timestamptz
);
alter table public.student_verifications enable row level security;
-- No browser-side access policies: instructor endpoints use server-side service role
-- only after validating the signed-in user's instructor/admin role.
