-- ============ TORCUATO BEACH SEVEN · base de datos ============
-- Pegar todo en Supabase → SQL Editor → Run. Se corre una sola vez.

-- Accesos al Admin: mails habilitados. Cada persona crea su cuenta en el sitio con ese mail
-- (botón "Acceso organización") y confirma el mail que le llega.
create table public.admins (
  email text primary key check (email = lower(email))
);

create or replace function public.is_admin() returns boolean
language sql stable security definer set search_path = public, auth
as $$
  select exists (
    select 1 from public.admins a
    join auth.users u on lower(u.email) = a.email
    where u.id = auth.uid() and u.email_confirmed_at is not null
  )
$$;

-- Parte pública: fixture, grupos, resultados, agenda, mapa y escudos (una sola fila).
create table public.tb_state (
  id int primary key check (id = 1),
  data jsonb not null,
  updated_at timestamptz not null default now()
);

-- Parte privada: equipos inscriptos, ventas de fiesta, caja, ajustes y organización.
create table public.adm_docs (
  col text not null,
  id text not null,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (col, id)
);

alter table public.admins enable row level security;
alter table public.tb_state enable row level security;
alter table public.adm_docs enable row level security;

create policy "estado: todos leen" on public.tb_state for select to anon, authenticated using (true);
create policy "estado: admin escribe" on public.tb_state for all to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "admin: datos privados" on public.adm_docs for all to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "admins: ver" on public.admins for select to authenticated using (public.is_admin());
create policy "admins: agregar" on public.admins for insert to authenticated with check (public.is_admin());
create policy "admins: quitar" on public.admins for delete to authenticated using (public.is_admin());

grant execute on function public.is_admin() to anon, authenticated;

-- Resultados en vivo: el sitio se actualiza solo cuando se publica algo.
alter publication supabase_realtime add table public.tb_state;

-- Primer acceso (vos). Cambiá el mail si vas a usar otro.
insert into public.admins (email) values ('lucasfernandezm01@gmail.com');
