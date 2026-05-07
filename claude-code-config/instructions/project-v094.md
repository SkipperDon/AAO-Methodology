## PROJECT: v0.9.4 — d3kOS Mobile Companion App

**When working on v0.9.4, the following rules are MANDATORY in addition to all rules above.**

### Strategy Document (read before any mobile work)

Full strategy: `/home/boatiq/Helm-OS/deployment/docs/MOBILE_APP_STRATEGY_BRIEF.md` v2.0.0 Q&A decision record: `/home/boatiq/Helm-OS/deployment/docs/MOBILE_APP_QA_RECORD.md` (authoritative source)

### Platform Summary

- **App:** PWA hosted at `atmyboat.com/staging/app/` (HostPapa) — no App Store, no Apple/Google terms, no 30% cut

- **Live tunnel (Pi ↔ phone):** WebRTC/STUN — P2P firewall traversal, $0 continuous cost

- **Command queue / OTA / Fix My Pi:** HostPapa PHP + MySQL message broker (already paid)

- **Payments:** Stripe on atmyboat.com only — never in-app

- **Does NOT compete with ActiveCaptain** — no marina/community features

### Connectivity Architecture Rules (non-negotiable)

- Pi ↔ phone live connection = WebRTC/STUN P2P — not polling, not message broker

- STUN servers: Google/Cloudflare public (free) — no account required

- TURN server: deferred — add only if real user testing proves necessary

- No open inbound ports on Pi — ever

- Pi always initiates outbound — never accepts inbound connections

- Tailscale: REMOVE from Pi before v0.9.4 build begins — was never operator's choice

### v1.1 Upgrade Path

- Option C (self-hosted UDP hole punching coordination server) replaces STUN in v1.1

- Do NOT build Option C in v0.9.4 — it is explicitly deferred

### Never Do on v0.9.4

- Use Tailscale for any purpose — it must be removed, not repurposed

- Build a TURN server unless user testing in production proves STUN is insufficient

- Use App Store distribution — PWA only

- Process payments inside the app — Stripe on atmyboat.com only

- Store user question text — token counts and timestamps only

- Send GPS coordinates to AI — summary stats only

- Build Option C self-hosted coordination server — that is v1.1
