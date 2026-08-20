-- Айсберг Тани: схема хранилища.
-- Выполнить один раз в Supabase: Dashboard → SQL Editor → New query → вставить → Run.

create table if not exists public.stories (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  story text not null,
  author text not null default '',
  img_url text not null default '',
  x double precision not null,
  y double precision not null,
  created_at timestamptz not null default now()
);

alter table public.stories enable row level security;

-- Сайт публичный и анонимный: читать, добавлять и удалять может любой гость.
create policy "anyone can read stories"
  on public.stories for select using (true);
create policy "anyone can add stories"
  on public.stories for insert with check (true);
create policy "anyone can delete stories"
  on public.stories for delete using (true);

-- Бакет для фотографий (публичное чтение).
insert into storage.buckets (id, name, public)
values ('photos', 'photos', true)
on conflict (id) do nothing;

create policy "public read photos"
  on storage.objects for select
  using (bucket_id = 'photos');

create policy "anyone can upload photos"
  on storage.objects for insert
  with check (bucket_id = 'photos');
