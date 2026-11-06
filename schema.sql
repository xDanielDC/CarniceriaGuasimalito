-- Ejecutar completo en Supabase → SQL Editor → New query → Run

create table if not exists products (
  id text primary key,
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  name text not null,
  cat text default '',
  unit text default 'kg',
  cost numeric not null default 0,
  price numeric not null default 0,
  stock numeric not null default 0,
  updated_at timestamptz default now()
);

create table if not exists sales (
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  n int not null,
  t timestamptz not null default now(),
  cust text default '',
  pay text,
  recv numeric default 0,
  total numeric not null default 0,
  profit numeric not null default 0,
  void boolean not null default false,
  lines jsonb not null default '[]',
  primary key (user_id, n)
);

create table if not exists settings (
  user_id uuid primary key default auth.uid() references auth.users on delete cascade,
  biz text default 'Supermercado Guasimalito',
  addr text default 'Av. 14 N° 53B-09, Guasimal, Bello',
  next int not null default 1
);

alter table products enable row level security;
alter table sales enable row level security;
alter table settings enable row level security;

create policy "own products" on products for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own sales" on sales for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own settings" on settings for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
