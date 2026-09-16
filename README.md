# SOP Capacidade & M.O. — Parque Fabril (PWA + Supabase + Vercel)

Simulador de S&OP Data-Driven — capacidade instalada, mão de obra e cenários.

## Deploy Web (Vercel)
1. Crie um repositório vazio no GitHub: `cesarneovia-ops/sop-capacidade` (não inicialize com README).
2. No PowerShell, dentro da pasta `SOP-App`:
   ```powershell
   git init
   git add .
   git commit -m "v21-abf: PWA + Supabase"
   git branch -M main
   git remote add origin https://github.com/cesarneovia-ops/sop-capacidade.git
   git push -u origin main
   ```
   Se pedir login, use seu Personal Access Token (GitHub > Settings > Developer settings > Tokens).
3. Em https://vercel.com/new → **Import Git Repository** → selecione `sop-capacidade` → Deploy. Pronto: `https://sop-capacidade.vercel.app`.

## Supabase (sem nada no notebook)
1. No Supabase, crie um projeto (se ainda não tem).
2. Vá em **SQL Editor** → cole o conteúdo de `supabase-schema.sql` → Run.
3. Em **Settings → API**, copie `URL` e `anon key` e cole em `index.html` nas duas linhas:
   ```js
   const SUPABASE_URL = 'https://SEU-PROJETO.supabase.co';
   const SUPABASE_ANON_KEY = 'SUA-ANON-KEY';
   ```
   Faça commit + push novamente:
   ```powershell
   git add index.html; git commit -m "config supabase"; git push
   ```
   A Vercel redeploya automaticamente. Dados passam a ficar na nuvem (tabela `sop_config`).

## Mobile (PWA Instalável)
Após publicado na Vercel, abra a URL no celular:
- **Android (Chrome):** ⋮ → Instalar app
- **iOS (Safari):** Compartilhar → Adicionar à Tela de Início

Funciona offline após o primeiro acesso (via `sw.js`).

## Estrutura
- `index.html` — app single-file + PWA + Supabase
- `manifest.json` / `sw.js` / `icons/` — PWA
- `supabase-schema.sql` — tabela na nuvem
- `vercel.json` — headers de cache
