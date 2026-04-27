# AAO Data Collection System — Architecture Document

**Version:** 1.1  
**Date:** 2026-04-27  
**Author:** Donald Moskaluk — AtMyBoat.com | AAO Project  
**Status:** PLAN — approved for Phase 1 build  
**Changes v1.1:** Q3 resolved — zero-config via CLAUDE.md snippet (no separate config file, no project_type). Q4 resolved — collector in aao-methodology-repo, PHP files in Helm-OS/deployment/research/.  

---

## 1. Purpose

This document defines the architecture for the AAO Session Data Collection System — a voluntary, privacy-respecting pipeline that allows AAO methodology practitioners to contribute their session quality metrics to a central research dataset.

The system supports the research paper *Governing the AI Productivity Promise* (Moskaluk, 2026) and enables ongoing multi-organization validation of the AAO methodology's effectiveness.

---

## 2. Design Principles

| Principle | Implementation |
|-----------|---------------|
| Zero friction for contributors | Single Python file, stdlib only — no pip installs, no config file. API key delivered as a one-line snippet pasted into the contributor's existing CLAUDE.md. |
| Privacy by design | Metrics only leave the machine — no code, prompts, or project names |
| Review before send | Contributors see a preview and confirm before every submission |
| Open public participation | Anyone can register and contribute |
| Deduplication safe | Resubmitting the same session is harmless |
| IP-identified contributors | Server records hashed IP to count unique contributing organizations |
| Backfill capable | Existing SESSION_LOG.md history can be submitted in a single pass |

---

## 3. System Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│  CONTRIBUTOR MACHINE  (Windows / Mac / Linux)                    │
│                                                                  │
│  CLAUDE.md  ──► registration link + aao_api_key: aao_...       │
│      │               (API key lives here — no separate config)   │
│      │                                                           │
│  aao-collector.py  (reads API key from CLAUDE.md automatically) │
│      │                                                           │
│      ├── reads SESSION_LOG.md                                    │
│      ├── parses session blocks (last session OR all --backfill)  │
│      ├── strips project data → metrics only                      │
│      ├── shows preview table → contributor types Y to confirm    │
│      └── HTTPS POST ─────────────────────────────────────────►  │
└──────────────────────────────────────────────────────────────────┘
                                      │
                            TLS 1.2+ / HTTPS
                            X-API-Key: <key>
                            Content-Type: application/json
                                      │
                                      ▼
┌──────────────────────────────────────────────────────────────────┐
│  HOSTPAPA — atmyboat.com/research/                               │
│                                                                  │
│  index.html           Public dashboard (Chart.js CDN)           │
│  register/            Registration form + API key issuance      │
│  aao-submit.php       Receives + validates + stores submissions  │
│  aao-data.php         Public aggregate JSON API                  │
│                                                                  │
│  MySQL                                                           │
│    aao_contributors   (id, api_key, email, org, ip_hash, ...)   │
│    aao_sessions       (metrics, contributor_token, ip_hash, ...) │
└──────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Specifications

### 4.1 Local Collector — `aao-collector.py`

**Language:** Python 3.6+  
**Dependencies:** stdlib only (`urllib.request`, `json`, `hashlib`, `pathlib`, `datetime`, `re`, `argparse`)  
**Platform:** Windows, Mac, Linux — no installation required beyond Python itself  
**Distribution:** Direct download from `https://atmyboat.com/research/`  

**Operating modes:**

| Mode | Command | Behaviour |
|------|---------|-----------|
| Default | `python aao-collector.py` | Parses last session block from SESSION_LOG.md |
| Backfill | `python aao-collector.py --backfill` | Parses ALL sessions, shows list, submits confirmed ones |
| Dry run | `python aao-collector.py --dry-run` | Parses and previews — no network call |

**Processing sequence:**

```
1. Scan for CLAUDE.md in current dir and up to 3 parent dirs → extract aao_api_key: value
   If not found: print registration URL and exit with instructions
2. Locate SESSION_LOG.md (current dir, or --log path override)
3. Parse session block(s) → extract metrics
4. Strip all non-metric content (project names, file names, notes)
5. Display preview table to contributor
6. Prompt: "Submit? [Y/n]"
7. POST payload to endpoint with API key header
8. Print confirmation (session_id accepted) or error message
9. Append result to local aao-collector.log
```

**No config file.** The API key is a single line in the contributor's `CLAUDE.md`:

```markdown
## AAO Research Contribution
aao_api_key: aao_a3f7c2b1...
```

The collector finds this line automatically. No separate file to create or maintain.

**Preview table format (shown before every submission):**

```
─────────────────────────────────────────────────
 AAO Session Collector — Preview Before Send
─────────────────────────────────────────────────
 Session ID  : S71
 Date        : 2026-04-27
 SQS         : 95
 SCR         : 100
 SGCR        : 100
 REC         : 0
 MLS         : 1
 UAC         : 0
 AAO version : 1.8
─────────────────────────────────────────────────
 No project names, file names, or code are sent.
 Submit? [Y/n]:
```

---

### 4.2 CLAUDE.md Integration

The AAO CLAUDE.md template (distributed via `github.com/SkipperDon/aao-methodology`) includes a **Data Contribution** section. Contributors who adopt AAO receive this section automatically — no separate announcement required.

**Section added to CLAUDE.md template (static — no API key yet):**

```markdown
## AAO Research Data Contribution (optional)

Contribute your session metrics to the AAO research dataset.
Register at https://atmyboat.com/research/ — you will receive a snippet
to paste below. Download aao-collector.py from the same page.
Run `python aao-collector.py` after any session to submit.
No code, prompts, or project names are transmitted — metrics only.
```

**After registration — contributor pastes their personal snippet below the above:**

```markdown
## AAO Research Contribution
aao_api_key: aao_a3f7c2b1...
```

The collector scans CLAUDE.md for the `aao_api_key:` line automatically.
No separate config file is ever created.

**Session-close command integration (`commands/session-close.md`):**

A reminder line is added after the SQS block:

```
Optional: run `python aao-collector.py` to contribute this session
to the AAO research dataset → https://atmyboat.com/research/
```

This ensures contributors are prompted at the natural moment — right after session close — without making it mandatory.

---

### 4.3 Registration System

**URL:** `https://atmyboat.com/research/register/`  
**From address:** `admin@atmyboat.com`  
**Platform:** HostPapa PHP + MySQL (existing infrastructure)  

**Registration form fields:**

| Field | Required | Notes |
|-------|----------|-------|
| Email address | Yes | Used for key delivery only |
| Organization | No | Optional — helps understand contributor diversity |
| AAO version in use | No | Pre-filled "1.8" |
| Data use agreement checkbox | Yes | "I confirm this data is anonymized and consent to research use" |

**On submit:**
1. Generate API key: 32-char random hex with `aao_` prefix
2. Store hashed API key + hashed email in `aao_contributors`
3. Record SHA-256 of registration IP in `ip_hash`
4. Send email from `admin@atmyboat.com` with: API key, CLAUDE.md snippet to paste, download link for aao-collector.py
5. Redirect to confirmation page with download link

**Registration email includes this ready-to-paste CLAUDE.md snippet:**
```
## AAO Research Contribution
aao_api_key: aao_<your-key-here>
```

**API key format:** `aao_` + 32 hex chars (e.g., `aao_a3f7c2b1...`)  
The `aao_` prefix makes keys recognizable without being guessable.

---

### 4.4 Submission Endpoint — `aao-submit.php`

**URL:** `https://atmyboat.com/research/aao-submit.php`  
**Method:** `POST`  
**Content-Type:** `application/json`  
**Auth:** `X-API-Key: aao_<key>` header  

**Processing sequence:**

```
1. Validate X-API-Key → look up contributor
2. Parse JSON body → validate against schema (required fields, value ranges)
3. Reject unknown fields (strict schema enforcement)
4. Check UNIQUE(contributor_token, session_id) → skip duplicate, return 200 with "already recorded"
5. Record SHA-256(REMOTE_ADDR) as ip_hash in both tables
6. INSERT into aaa_sessions
7. UPDATE aao_contributors SET submission_count = submission_count + 1
8. Return {"ok": true, "session_id": "<id>", "total_submitted": N}
```

**IP hashing note:** `REMOTE_ADDR` is hashed with SHA-256 before storage. Raw IP addresses are never stored. The hash is sufficient to:
- Count distinct contributing organizations (distinct ip_hash values in aao_contributors)
- Detect abuse (same ip_hash submitting anomalous volumes)
- Identify if multiple API keys originate from the same location

**Validation rules:**

| Field | Required | Validation |
|-------|----------|------------|
| session_id | Yes | Non-empty string, max 20 chars |
| date | Yes | ISO 8601 format YYYY-MM-DD |
| sqs | Yes | 0–100 numeric |
| scr | No | 0–100 numeric |
| sgcr | No | 0–100 numeric |
| rec | No | Integer ≥ 0 |
| mls | No | 0 or 1 |
| uac | No | Integer ≥ 0 |
| aao_version | No | String, max 10 chars |
| agent_version | No | String, max 10 chars |
| notes | No | String, max 200 chars — collector warns "no project names" |

**Response codes:**

| Code | Meaning |
|------|---------|
| 200 | Accepted or already recorded (idempotent) |
| 400 | Validation error — body contains field name and reason |
| 401 | Invalid or missing API key |
| 429 | Rate limited (max 50 submissions per API key per day) |
| 500 | Server error |

---

### 4.5 Public Data API — `aao-data.php`

**URL:** `https://atmyboat.com/research/aao-data.php`  
**Method:** `GET`  
**Auth:** None — fully public  
**Cache:** 5-minute cache headers  

**Response (aggregate only — no individual sessions exposed):**

```json
{
  "meta": {
    "total_sessions": 412,
    "total_contributors": 23,
    "last_updated": "2026-04-27T14:32:00Z",
    "aao_versions": ["1.6", "1.7", "1.8"]
  },
  "sqs": {
    "mean": 84.3,
    "median": 87.0,
    "std_dev": 12.1,
    "min": 35.0,
    "max": 100.0,
    "distribution": [0, 2, 8, 24, 67, 89, 112, 87, 23]
  },
  "rec": {
    "mean": 0.8,
    "zero_pct": 61.2,
    "distribution": {"0": 252, "1": 98, "2": 41, "3+": 21}
  },
  "mls": {
    "success_rate_pct": 78.4
  },
  "trend": [
    {"month": "2026-01", "mean_sqs": 79.2, "sessions": 34},
    {"month": "2026-02", "mean_sqs": 81.5, "sessions": 47}
  ]
}
```

**Optional query parameters:**

| Parameter | Example | Effect |
|-----------|---------|--------|
| `aao_version` | `?aao_version=1.8` | Filter to a specific AAO version |
| `from` | `?from=2026-01-01` | Sessions after this date |
| `format` | `?format=csv` | Returns CSV instead of JSON |

---

### 4.6 Public Dashboard — `index.html`

**URL:** `https://atmyboat.com/research/`  
**Technology:** Static HTML + Chart.js (CDN) + vanilla JS  
**No build step, no framework, no npm**  

**Dashboard sections:**

1. **Hero stats** — total sessions, total contributors, mean SQS (live from aao-data.php)
2. **SQS Trend** — line chart, monthly mean SQS over time
3. **SQS Distribution** — histogram (0–100 in 10-pt buckets)
4. **REC Distribution** — bar chart (0, 1, 2, 3+ recovery events)
5. **Memory Load Success rate** — single percentage
6. **Contribute** — registration CTA + download link

---

## 5. Database Schema

```sql
-- Contributors table
CREATE TABLE aao_contributors (
  id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  api_key_hash     CHAR(64) NOT NULL UNIQUE,  -- SHA-256 of API key
  email_hash       CHAR(64) NOT NULL,          -- SHA-256 of email
  org              VARCHAR(100),
  ip_hash          CHAR(64) NOT NULL,          -- SHA-256 of registration IP
  aao_version      VARCHAR(10),
  registered_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  submission_count INT UNSIGNED NOT NULL DEFAULT 0,
  active           TINYINT(1) NOT NULL DEFAULT 1
);

-- Sessions table
CREATE TABLE aao_sessions (
  id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  contributor_token CHAR(64) NOT NULL,          -- SHA-256 of api_key
  session_id        VARCHAR(20) NOT NULL,
  date              DATE NOT NULL,
  sqs               DECIMAL(5,2),
  scr               DECIMAL(5,2),
  sgcr              DECIMAL(5,2),
  rec               SMALLINT UNSIGNED,
  mls               TINYINT(1),
  uac               SMALLINT UNSIGNED,
  aao_version       VARCHAR(10),
  agent_version     VARCHAR(10),
  notes             VARCHAR(200),
  ip_hash           CHAR(64) NOT NULL,          -- SHA-256 of submission IP
  submitted_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_contributor_session (contributor_token, session_id)
);
```

**Index strategy:**
- `aao_sessions(contributor_token)` — contributor's own session queries
- `aao_sessions(date)` — trend queries
- `aao_sessions(aao_version)` — version-filtered aggregates

---

## 6. JSON Submission Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12",
  "title": "AAO Session Submission",
  "version": "1.0",
  "type": "object",
  "required": ["session_id", "date", "sqs"],
  "additionalProperties": false,
  "properties": {
    "session_id":    { "type": "string",  "maxLength": 20 },
    "date":          { "type": "string",  "format": "date" },
    "sqs":           { "type": "number",  "minimum": 0, "maximum": 100 },
    "scr":           { "type": "number",  "minimum": 0, "maximum": 100 },
    "sgcr":          { "type": "number",  "minimum": 0, "maximum": 100 },
    "rec":           { "type": "integer", "minimum": 0 },
    "mls":           { "type": "integer", "enum": [0, 1] },
    "uac":           { "type": "integer", "minimum": 0 },
    "aao_version":   { "type": "string",  "maxLength": 10 },
    "agent_version": { "type": "string",  "maxLength": 10 },
    "notes":         { "type": "string",  "maxLength": 200 }
  }
}
```

---

## 7. Contributor Onboarding Flow

```
Step 1 — Adopt AAO methodology
  Install CLAUDE.md template from github.com/SkipperDon/aao-methodology
  CLAUDE.md includes "Data Contribution" section with registration link

Step 2 — Register (one time, ~2 minutes)
  Visit https://atmyboat.com/research/
  Click "Contribute Your Data"
  Enter email + optional org name
  Check data use agreement
  Receive API key at admin@atmyboat.com

Step 3 — Configure collector (one time, ~30 seconds)
  Download aao-collector.py from the research page
  Paste the CLAUDE.md snippet from the registration email into your CLAUDE.md:
    ## AAO Research Contribution
    aao_api_key: aao_<your key>
  No other configuration needed.

Step 4 — Submit sessions (ongoing, ~10 seconds per session)
  At session end, run: python aao-collector.py
  Review the preview table
  Type Y to submit

Step 5 — Backfill historical sessions (optional, one time)
  Run: python aao-collector.py --backfill
  Select which sessions to submit from the displayed list
  Confirm and submit
```

---

## 8. Privacy and Compliance

### What is transmitted

| Data | Transmitted | Notes |
|------|-------------|-------|
| Session metrics (SQS, SCR, etc.) | Yes | Core dataset |
| Session date | Yes | Used for trend analysis |
| AAO version | Yes — optional | Used for version-cohort analysis |
| Notes | Yes — optional | Max 200 chars; collector warns against project names |
| Source code | **Never** | Not parsed, not sent |
| File names | **Never** | Stripped before preview |
| Prompt text | **Never** | Not parsed, not sent |
| Project names | **Never** | Stripped; contributor warned in preview |
| IP address (raw) | **Never** | Server hashes before storage |

### Compliance

- **GDPR / Canadian PIPEDA:** Session metrics are research data, not personal data. Email collected only for key delivery — hashed before storage — not shared — deletable on request. Consent obtained at registration via data use agreement checkbox.
- **Data use agreement:** Creative Commons BY-NC. Contributors confirm anonymization and consent to use in academic research.
- **Right to deletion:** Contributor emails `admin@atmyboat.com` requesting deletion. All rows matching their `contributor_token` are deleted within 7 days.
- **No re-identification:** Aggregate API never returns fewer than 5 sessions per bucket (minimum cell size rule — prevents reverse engineering individual submissions).

---

## 9. Deployment Plan

### Phase 1 — MVP (HostPapa, build now)

**Files to create:**

| File | Location | Purpose |
|------|----------|---------|
| `index.html` | `atmyboat.com/research/` | Landing page + CTA |
| `register/index.php` | `atmyboat.com/research/register/` | Registration form |
| `aao-register.php` | `atmyboat.com/research/` | Registration handler (PHP) |
| `aao-submit.php` | `atmyboat.com/research/` | Submission endpoint |
| `aao-data.php` | `atmyboat.com/research/` | Public aggregate API |
| `aao-config.php` | `atmyboat.com/research/` | DB credentials (never committed) |
| `privacy/index.html` | `atmyboat.com/research/privacy/` | Privacy policy |
| `aao-collector.py` | Served as download | Local collector script — no config file needed |

**MySQL tables:** `aao_contributors`, `aao_sessions` (see Section 5)

**Email:** PHP `mail()` via HostPapa with From: `admin@atmyboat.com`

### Phase 2 — Dashboard (after 3–5 contributors)

Add Chart.js dashboard to `index.html`. Data comes from `aao-data.php`. No new infrastructure.

### Phase 3 — Researcher API (after 25 sessions collected)

Expand `aao-data.php` with query parameters (`aao_version`, `project_type`, `from`, `format=csv`). Add API documentation page. Announce to research partners.

### Phase 4 — Scale (if needed)

Migrate submission endpoint to Railway or Render (free tier Python/Node.js) if HostPapa shared hosting becomes a bottleneck. Phase 1–3 can handle hundreds of contributors on shared PHP hosting.

---

## 10. CLAUDE.md Template Changes

Two files in `github.com/SkipperDon/aao-methodology` require updates as part of this project:

### `CLAUDE.md` template — new section

Add after the "Session End" section:

```markdown
## AAO Research Data Contribution (optional)

Contribute your session metrics to the AAO research dataset.
Register at https://atmyboat.com/research/ — you will receive a snippet
to paste below. Download aao-collector.py from the same page.
Run `python aao-collector.py` after any session to submit.
No code, prompts, or project names are transmitted — metrics only.
Backfill all prior sessions with: python aao-collector.py --backfill

<!-- paste your registration snippet below this line -->
```

After registering, the contributor adds one line below the comment:

```markdown
aao_api_key: aao_<their-key>
```

The collector finds this line automatically — no separate file, no additional setup.

### `commands/session-close.md` — reminder line

Add after the SQS quality metrics block:

```
─────────────────────────────────────────────────────
Contributing to AAO research? Run: python aao-collector.py
Register at https://atmyboat.com/research/
─────────────────────────────────────────────────────
```

---

## 11. Contributor Count and Monitoring

Don's visibility into the dataset:

| What to see | How |
|-------------|-----|
| Total contributors | `SELECT COUNT(*) FROM aao_contributors WHERE active=1` |
| Distinct organizations by IP | `SELECT COUNT(DISTINCT ip_hash) FROM aao_contributors` |
| Recent activity | `SELECT contributor_token, COUNT(*), MAX(submitted_at) FROM aao_sessions GROUP BY contributor_token ORDER BY MAX(submitted_at) DESC` |
| Sessions per contributor | `submission_count` in `aao_contributors` |
| Total sessions | `SELECT COUNT(*) FROM aao_sessions` |

These queries are available via the Admin CRM (can be added as a `/research-stats` route) or run directly via HostPapa phpMyAdmin.

---

## 12. Open Items Before Build Starts

| # | Item | Status | Owner |
|---|------|--------|-------|
| 1 | Confirm HostPapa staging vs live deploy order | OPEN | Don |
| 2 | Confirm email deliverability from `admin@atmyboat.com` on HostPapa | OPEN | Don (test) |
| 3 | project_type removed — zero-config via CLAUDE.md snippet | **RESOLVED v1.1** | — |
| 4 | `aao-collector.py` in `aao-methodology-repo/data-collection/`; PHP files in `Helm-OS/deployment/research/` | **RESOLVED v1.1** | — |
| 5 | UpdraftPlus backup before any HostPapa DB changes | OPEN | Don |

---

*Document version 1.0 — 2026-04-27*  
*Next revision: after Phase 1 build is deployed and first external contributor confirmed*
