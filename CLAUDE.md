# Torcuato Beach Seven (TB7s)

Sitio del evento (Hindú Club, 12/12/2026): Rugby 7s, Hockey Mixto y Fútbol Femenino. Dueño: Lucas (español rioplatense, respuestas cortas). Proyecto aparte de Line & Maul: no mezclar.

- `index.html`: todo el sitio (HTML + CSS + JS en un archivo). Se publica solo con GitHub Pages (`.github/workflows/pages.yml`) al hacer push a `main`.
- Base y login: Supabase propio del TB7s (`SB_URL` y `SB_KEY` arriba del script en `index.html`). Esquema en `supabase/01_schema.sql` (se corre a mano en el SQL Editor; desde el entorno de Claude no hay acceso de red a Supabase).
- Tablas: `tb_state` (una fila, id 1: todo lo público: comps, grupos, partidos, itinerario, mapa, escudos en data URI), `adm_docs` (privado: col `adm/v1/insc`, `adm/v1/fiesta`, `adm/v1/caja`, y `adm` con ids `config` y `equipo`), `admins` (mails habilitados; `is_admin()` exige mail confirmado).
- Lo público se edita en el sitio con "Editar" (queda como borrador en el navegador) y se sube con "Publicar"; el resto de los celulares lo recibe por Realtime (y cada 60 s).
- `SEED` en `index.html` es el estado inicial: si la tabla está vacía, el primer admin que entra lo sube.
- Nunca subir al repo datos privados (teléfonos, montos): van solo en la base.
- Versión: en cada cambio de `index.html` actualizar `APP_V` (arriba del script) y `version.json` con el mismo valor (AAAAMMDDHHMMSS). La app compara y se recarga sola cuando hay versión nueva.
