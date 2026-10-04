-- Run once in Supabase: SQL Editor -> New query -> paste -> Run.
-- One row per login holds that person's settings and daily log.
create table if not exists public.bulk_data (
  user_id uuid primary key default auth.uid() references auth.users on delete cascade,
  settings jsonb not null default '{}',
  logs jsonb not null default '{}',
  updated_at timestamptz not null default now()
);

alter table public.bulk_data enable row level security;

-- A signed-in user can only see and change their own row. Anyone without a login gets nothing.
create policy "own row only" on public.bulk_data
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
