-- AAO Artifact Repository Schema
-- Human Sign-Off and Audit Trail for AI-Produced Artifacts
-- Part of the AAO — Autonomous Action Operating Methodology
-- © 2026 Donald Moskaluk | AtMyBoat.com
--
-- DISCLAIMER: This schema is part of a framework under active development
-- and has not been formally validated. Apply professional judgment before
-- deploying in production environments.
--
-- Database: PostgreSQL 14+ recommended
-- Principle: Append-only — no UPDATE or DELETE on core tables
-- Version: 1.1 (adds diversity tracking and new artifact types)

-- ============================================================
-- OPERATORS — Authorized individuals who can sign off artifacts
-- ============================================================

CREATE TABLE aao_operators (
    operator_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operator_name       VARCHAR(200) NOT NULL,
    operator_email      VARCHAR(200) NOT NULL UNIQUE,
    operator_role       VARCHAR(50) NOT NULL CHECK (operator_role IN ('operator', 'administrator', 'auditor')),

    -- NEW: Diversity tracking fields (Section 14)
    role_classification VARCHAR(50) NOT NULL
                        CHECK (role_classification IN ('Technical', 'Operational', 'Risk/Compliance', 'Other')),
    disciplinary_category VARCHAR(100) NOT NULL,  -- e.g. 'Software Engineering', 'Marine Operations', 'Legal/Regulatory'

    code_hash           VARCHAR(200) NOT NULL,   -- bcrypt/argon2 hash of Authorization Code
    code_salt           VARCHAR(100) NOT NULL,   -- per-operator salt
    code_issued_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    code_expires_at     TIMESTAMPTZ,             -- NULL = no expiry (not recommended)
    code_active         BOOLEAN NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by          UUID REFERENCES aao_operators(operator_id),
    notes               TEXT
);

CREATE INDEX idx_operators_role_classification ON aao_operators(role_classification);
CREATE INDEX idx_operators_disciplinary ON aao_operators(disciplinary_category);

-- Code rotation history — old codes kept for audit purposes (as hashes only)
CREATE TABLE aao_operator_code_history (
    history_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operator_id         UUID NOT NULL REFERENCES aao_operators(operator_id),
    old_code_hash       VARCHAR(200) NOT NULL,
    rotated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    rotated_by          UUID REFERENCES aao_operators(operator_id),
    rotation_reason     VARCHAR(500)
);

-- ============================================================
-- SESSIONS — AI work sessions that produce artifacts
-- ============================================================

CREATE TABLE aao_sessions (
    session_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_ref         VARCHAR(100) UNIQUE,      -- human-readable reference e.g. AAO-2026-0042
    ai_system_id        VARCHAR(100) NOT NULL,    -- which AI system ran this session
    ai_model_version    VARCHAR(100),
    initiated_by        UUID REFERENCES aao_operators(operator_id),
    started_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at            TIMESTAMPTZ,
    session_status      VARCHAR(50) NOT NULL DEFAULT 'active'
                        CHECK (session_status IN ('active', 'pending_review', 'closed', 'flagged')),
    review_deadline     TIMESTAMPTZ,             -- when sign-off grace period expires
    session_notes       TEXT,

    -- NEW: Diversity metrics tracking (Section 14.5)
    diversity_score     INTEGER,                  -- 0-3: how many different disciplines participated
    participating_roles JSONB                     -- Array of role classifications that participated
);

CREATE INDEX idx_sessions_diversity ON aao_sessions(diversity_score);

-- ============================================================
-- ARTIFACTS — Immutable AI-produced outputs
-- ============================================================

CREATE TABLE aao_artifacts (
    artifact_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    artifact_ref        VARCHAR(100) UNIQUE,     -- human-readable e.g. ART-2026-0127
    session_id          UUID NOT NULL REFERENCES aao_sessions(session_id),
    artifact_type       VARCHAR(50) NOT NULL
                        CHECK (artifact_type IN (
                            'DIAGNOSTIC_REPORT',
                            'ACTION_RECORD',
                            'CHANGE_PROPOSAL',
                            'SESSION_SUMMARY',
                            'FAILURE_REPORT',
                            'SESSION_TESTING_GATE',
                            'DECOMMISSION',              -- NEW: Section 15
                            'STAKEHOLDER_FEEDBACK',      -- NEW: Section 16
                            'CUSTOM'
                        )),
    artifact_title      VARCHAR(500) NOT NULL,
    artifact_content    JSONB NOT NULL,          -- full artifact content, structured
    artifact_content_hash VARCHAR(200) NOT NULL, -- SHA-256 of content for integrity verification
    content_version     INTEGER NOT NULL DEFAULT 1,
    supersedes          UUID REFERENCES aao_artifacts(artifact_id), -- if this replaces a prior version
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    signoff_status      VARCHAR(50) NOT NULL DEFAULT 'pending'
                        CHECK (signoff_status IN ('pending', 'approved', 'rejected', 'flagged', 'superseded')),
    metadata            JSONB                   -- extensible metadata for implementation-specific fields
);

-- Prevent modification of artifact records (trigger-based enforcement)
-- Implementations MUST add a trigger or row-level security to block UPDATE on core columns
-- after initial INSERT. Only signoff_status may be updated via the aao_signoffs table insert.

-- ============================================================
-- SIGN-OFFS — Operator approvals of artifacts
-- ============================================================

CREATE TABLE aao_signoffs (
    signoff_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    artifact_id         UUID NOT NULL REFERENCES aao_artifacts(artifact_id),
    operator_id         UUID NOT NULL REFERENCES aao_operators(operator_id),
    code_hash_used      VARCHAR(200) NOT NULL,   -- hash of code at time of use (for audit trail)
    decision            VARCHAR(20) NOT NULL CHECK (decision IN ('approved', 'rejected', 'flagged')),
    operator_notes      TEXT,                    -- required if decision = 'rejected'
    signed_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    signing_ip          INET,                    -- IP address for anomaly detection
    session_id          UUID REFERENCES aao_sessions(session_id),

    -- NEW: Role classification at time of sign-off (denormalized for audit trail)
    operator_role_classification VARCHAR(50),
    operator_disciplinary_category VARCHAR(100)
);

CREATE INDEX idx_signoffs_role ON aao_signoffs(operator_role_classification);

-- After insert on aao_signoffs, update the artifact status (via trigger)
CREATE OR REPLACE FUNCTION aao_apply_signoff()
RETURNS TRIGGER AS $$
BEGIN
    -- Update artifact signoff status
    UPDATE aao_artifacts
    SET signoff_status = NEW.decision
    WHERE artifact_id = NEW.artifact_id;

    -- If a session summary is approved, update session diversity metrics
    IF NEW.decision = 'approved' THEN
        -- Calculate diversity score for session
        WITH session_diversity AS (
            SELECT
                s.session_id,
                COUNT(DISTINCT sf.operator_role_classification) AS diversity_score,
                json_agg(DISTINCT sf.operator_role_classification) AS participating_roles
            FROM aao_sessions s
            LEFT JOIN aao_artifacts a ON s.session_id = a.session_id
            LEFT JOIN aao_signoffs sf ON a.artifact_id = sf.artifact_id
            WHERE s.session_id = NEW.session_id
            GROUP BY s.session_id
        )
        UPDATE aao_sessions
        SET diversity_score = sd.diversity_score,
            participating_roles = sd.participating_roles,
            session_status = 'closed',
            ended_at = COALESCE(ended_at, NOW())
        FROM session_diversity sd
        WHERE aao_sessions.session_id = sd.session_id
        AND NOT EXISTS (
            SELECT 1 FROM aao_artifacts a
            LEFT JOIN aao_signoffs s ON a.artifact_id = s.artifact_id
            WHERE a.session_id = aao_sessions.session_id
            AND a.artifact_type = 'SESSION_SUMMARY'
            AND (s.decision IS NULL OR s.decision = 'pending')
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_apply_signoff
AFTER INSERT ON aao_signoffs
FOR EACH ROW EXECUTE FUNCTION aao_apply_signoff();

-- ============================================================
-- AUDIT LOG — All access to the repository is itself logged
-- ============================================================

CREATE TABLE aao_audit_access_log (
    log_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    accessor_id         UUID REFERENCES aao_operators(operator_id),
    access_type         VARCHAR(50) NOT NULL CHECK (access_type IN ('view', 'export', 'signoff', 'admin')),
    resource_type       VARCHAR(50),             -- 'artifact', 'session', 'operator', 'report'
    resource_id         UUID,
    access_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    access_ip           INET,
    export_format       VARCHAR(20),             -- 'pdf', 'json', 'csv' if access_type = 'export'
    query_params        JSONB                    -- filter params used for audit queries
);

-- ============================================================
-- VIEWS — Convenient audit and reporting views
-- ============================================================

-- All pending artifacts requiring sign-off
CREATE VIEW aao_pending_review AS
SELECT
    a.artifact_ref,
    a.artifact_type,
    a.artifact_title,
    a.created_at,
    s.session_ref,
    s.ai_system_id,
    s.review_deadline,
    CASE
        WHEN s.review_deadline < NOW() THEN 'OVERDUE'
        WHEN s.review_deadline < NOW() + INTERVAL '4 hours' THEN 'DUE SOON'
        ELSE 'ON TIME'
    END AS deadline_status,
    op.operator_name AS initiated_by_name
FROM aao_artifacts a
JOIN aao_sessions s ON a.session_id = s.session_id
LEFT JOIN aao_operators op ON s.initiated_by = op.operator_id
WHERE a.signoff_status = 'pending'
ORDER BY s.review_deadline ASC NULLS LAST;

-- Complete audit trail per artifact
CREATE VIEW aao_artifact_audit_trail AS
SELECT
    a.artifact_ref,
    a.artifact_type,
    a.artifact_title,
    a.created_at AS artifact_created,
    a.signoff_status,
    s.session_ref,
    s.ai_system_id,
    sf.signed_at,
    sf.decision,
    sf.operator_notes,
    op.operator_name AS signed_by,
    op.operator_email AS signed_by_email,
    sf.operator_role_classification,
    sf.operator_disciplinary_category,
    sf.signing_ip
FROM aao_artifacts a
JOIN aao_sessions s ON a.session_id = s.session_id
LEFT JOIN aao_signoffs sf ON a.artifact_id = sf.artifact_id
LEFT JOIN aao_operators op ON sf.operator_id = op.operator_id
ORDER BY a.created_at DESC;

-- Operator sign-off activity summary
CREATE VIEW aao_operator_signoff_summary AS
SELECT
    op.operator_name,
    op.operator_email,
    op.role_classification,
    op.disciplinary_category,
    COUNT(sf.signoff_id) AS total_signoffs,
    COUNT(CASE WHEN sf.decision = 'approved' THEN 1 END) AS approved,
    COUNT(CASE WHEN sf.decision = 'rejected' THEN 1 END) AS rejected,
    COUNT(CASE WHEN sf.decision = 'flagged' THEN 1 END) AS flagged,
    MIN(sf.signed_at) AS first_signoff,
    MAX(sf.signed_at) AS last_signoff
FROM aao_operators op
LEFT JOIN aao_signoffs sf ON op.operator_id = sf.operator_id
GROUP BY op.operator_id, op.operator_name, op.operator_email, op.role_classification, op.disciplinary_category;

-- NEW: Diversity metrics view (Section 14.5)
CREATE VIEW aao_diversity_metrics AS
SELECT
    s.session_ref,
    s.ai_system_id,
    s.diversity_score,
    s.participating_roles,
    COUNT(DISTINCT sf.operator_id) AS unique_operators,
    COUNT(DISTINCT sf.operator_role_classification) AS unique_roles,
    COUNT(DISTINCT sf.operator_disciplinary_category) AS unique_disciplines,
    json_agg(DISTINCT jsonb_build_object(
        'operator', op.operator_name,
        'role', sf.operator_role_classification,
        'discipline', sf.operator_disciplinary_category
    )) AS operator_diversity_breakdown
FROM aao_sessions s
LEFT JOIN aao_artifacts a ON s.session_id = a.session_id
LEFT JOIN aao_signoffs sf ON a.artifact_id = sf.artifact_id
LEFT JOIN aao_operators op ON sf.operator_id = op.operator_id
GROUP BY s.session_id, s.session_ref, s.ai_system_id, s.diversity_score, s.participating_roles;

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_artifacts_session ON aao_artifacts(session_id);
CREATE INDEX idx_artifacts_status ON aao_artifacts(signoff_status);
CREATE INDEX idx_artifacts_type ON aao_artifacts(artifact_type);
CREATE INDEX idx_artifacts_created ON aao_artifacts(created_at DESC);
CREATE INDEX idx_signoffs_artifact ON aao_signoffs(artifact_id);
CREATE INDEX idx_signoffs_operator ON aao_signoffs(operator_id);
CREATE INDEX idx_signoffs_signed_at ON aao_signoffs(signed_at DESC);
CREATE INDEX idx_sessions_status ON aao_sessions(session_status);
CREATE INDEX idx_access_log_accessor ON aao_audit_access_log(accessor_id);
CREATE INDEX idx_access_log_at ON aao_audit_access_log(access_at DESC);

-- ============================================================
-- NOTES FOR IMPLEMENTERS
-- ============================================================
-- 1. Add row-level security (RLS) policies to enforce role-based access
-- 2. The artifact_content_hash should be verified on read — detect tampering
-- 3. Consider pg_audit extension for database-level audit logging
-- 4. For high-volume implementations, partition aao_artifacts by created_at (monthly)
-- 5. The aao_audit_access_log table should be on a separate tablespace
--    with its own backup policy — it must survive even if the main DB is compromised
--
-- VERSION 1.1 CHANGES:
-- - Added role_classification and disciplinary_category to aao_operators
-- - Added diversity_score and participating_roles to aao_sessions
-- - Added operator_role_classification and operator_disciplinary_category to aao_signoffs
-- - Added DECOMMISSION and STAKEHOLDER_FEEDBACK artifact types
-- - Added aao_diversity_metrics view
-- - Updated aao_apply_signoff() trigger to calculate session diversity
-- - Added indexes for diversity tracking fields
