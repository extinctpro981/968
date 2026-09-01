-- Shared state for the Scrapa/Scarpa inventory app.
-- Run this once in Supabase SQL Editor.

create table if not exists public.scrapa_app_state (
  id text primary key,
  shoes jsonb not null default '[]'::jsonb,
  sales jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.scrapa_app_state enable row level security;

-- This app currently has no login/authentication. These policies allow the
-- browser app to read and update the single shared row using the publishable key.
drop policy if exists "scrapa_public_read" on public.scrapa_app_state;
drop policy if exists "scrapa_public_insert" on public.scrapa_app_state;
drop policy if exists "scrapa_public_update" on public.scrapa_app_state;

create policy "scrapa_public_read"
on public.scrapa_app_state
for select
to anon
using (true);

create policy "scrapa_public_insert"
on public.scrapa_app_state
for insert
to anon
with check (id = 'main');

create policy "scrapa_public_update"
on public.scrapa_app_state
for update
to anon
using (id = 'main')
with check (id = 'main');

-- Do not insert the initial row here. The app creates it on first launch,
-- using the current browser's existing data as the one-time migration source.
