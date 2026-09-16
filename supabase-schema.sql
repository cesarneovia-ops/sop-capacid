-- Supabase — SOP Capacidade & M.O. (v21-abf)
-- Cole este SQL em Supabase > SQL Editor > Run

-- 1) Tabela única de configuração (uma linha = estado atual do simulador)
create table if not exists public.sop_config (
  id uuid primary key default gen_random_uuid(),
  var_c2 integer not null default -10,
  var_c3 integer not null default 25,
  abs_pct numeric not null default 5,
  setup_c1 numeric not null default 0,
  setup_c2 numeric not null default 0,
  setup_c3 numeric not null default 1,
  data jsonb not null default '[]'::jsonb,
  version text not null default 'v21-abf',
  updated_at timestamptz not null default now()
);

-- Garante uma única linha (singleton)
create unique index if not exists sop_config_singleton on public.sop_config ((true));

-- RLS: habilita e libera leitura/escrita (ajuste depois se for por usuário)
alter table public.sop_config enable row level security;
drop policy if exists "allow all read" on public.sop_config;
drop policy if exists "allow all write" on public.sop_config;
create policy "allow all read" on public.sop_config for select using (true);
create policy "allow all write" on public.sop_config for all using (true) with check (true);

-- Função para auto-atualizar updated_at
create or replace function public.set_updated_at() returns trigger as $$
begin new.updated_at = now(); return new; end; $$ language plpgsql;
drop trigger if exists trg_sop_config_updated_at on public.sop_config;
create trigger trg_sop_config_updated_at before update on public.sop_config
for each row execute function public.set_updated_at();

-- Linha inicial (se ainda não existir)
insert into public.sop_config (var_c2, var_c3, abs_pct, setup_c1, setup_c2, setup_c3, data, version)
select -10, 25, 5, 0, 0, 1, '[]'::jsonb, 'v21-abf'
where not exists (select 1 from public.sop_config);
