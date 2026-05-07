## PROJECT: v0.9.3 — AtMyBoat.com Community Platform

**When working on v0.9.3, the following rules are MANDATORY in addition to all rules above.**

### Standing Instruction (read at session start for any v0.9.3 work)

Full standing instruction: `/home/boatiq/Helm-OS/deployment/v0.9.3/ATMYBOAT_STANDING_INSTRUCTION.md` Build reference: `/home/boatiq/Helm-OS/deployment/v0.9.3/ATMYBOAT_BUILD_REFERENCE.md` Design mockup: `/home/boatiq/Helm-OS/deployment/v0.9.3/atmyboat-mockup-v2-accessible.html`

### Platform Summary

- **Live site:** atmyboat.com — WordPress, Twenty Twenty theme, HostPapa shared hosting

- **Staging:** HostPapa Staging — all work here first, confirm with Don before any live deploy (Phase 4 complete 2026-04-12)

- **GitHub repo:** `github.com/SkipperDon/atmyboat-forum` — check before creating any file

- **AI model:** `claude-haiku-4-5-20251001` ONLY — hard cap $30/month in Anthropic Console

- **Deploy:** FTPS via `lftp` or cPanel Git VC — no SSH on HostPapa

### Architecture Rules (non-negotiable)

- All custom code in child theme only: `/wp-content/themes/twentytwenty-child/`

- AI is PHP + cURL only — no Node.js, no npm, no PM2, no Composer

- All API keys via `define()` in `atmyboat-config.php` — NEVER hardcode, NEVER commit this file

- No subdomains — all content at `atmyboat.com/subfolder`

- Never modify files outside `/forum`, `/products`, `/blog`, or the child theme

- Never store user question text — log token counts and timestamps only

- Never push to live — Don clicks "Push to Live" in cPanel, never Claude Code

### AODA Rules (enforced on every component)

- Minimum 18px body text, 1.8 line-height — non-negotiable

- Minimum 48×48px touch targets on all interactive elements

- Skip-to-content link as first focusable element on every page

- All colour pairs must pass WCAG 2.0 AA 4.5:1 minimum contrast

### Never Do on v0.9.3

- Suggest Flarum, a forum subdomain, or any separate forum server

- Suggest Node.js, npm, or server-level package management

- Use any AI model other than `claude-haiku-4-5-20251001`

- Set Gemini/Anthropic `MAX_TOKENS` above 1000

- Run WPReset on the live site

- Attempt SSH, WP-CLI, composer, or npm

- Deploy directly to live without verified UpdraftPlus backup
