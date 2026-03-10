-- AAO Audit Ledger Schema
-- Store locally on device. Sync to remote when connectivity available.
-- This table is append-only — never update or delete rows.

CREATE TABLE IF NOT EXISTS aao_audit_ledger (
  id                    INTEGER PRIMARY KEY AUTOINCREMENT,
  entry_id              TEXT NOT NULL UNIQUE,
  timestamp             TEXT NOT NULL,
  entry_type            TEXT NOT NULL,
  -- pre_execution | post_execution | rejected | security_flag | rollback

  session_id            TEXT NOT NULL,
  action_name           TEXT NOT NULL,
  parameters            TEXT,           -- JSON
  risk_level            TEXT,
  -- None | Low | Medium | High

  user_confirmed        INTEGER,        -- 0 or 1
  confirmation_method   TEXT,
  -- conversational | dialog | pin | none

  snapshot_id           TEXT,
  execution_output      TEXT,           -- truncated to 2000 chars
  health_check_result   TEXT,           -- JSON
  health_check_passed   INTEGER,        -- 0 or 1
  rollback_triggered    INTEGER,        -- 0 or 1
  rollback_outcome      TEXT,
  -- success | failed | null

  rejection_reason      TEXT,
  -- not_on_whitelist | invalid_parameters | confirmation_required | null

  security_flag         INTEGER DEFAULT 0,  -- 1 if injection pattern detected
  duration_ms           INTEGER,
  user_query_context    TEXT,           -- what user said that led to this action
  app_version           TEXT,
  created_at            TEXT DEFAULT (datetime('now'))
);

-- Index for session queries
CREATE INDEX IF NOT EXISTS idx_session
  ON aao_audit_ledger(session_id);

-- Index for time range queries
CREATE INDEX IF NOT EXISTS idx_timestamp
  ON aao_audit_ledger(timestamp);

-- Index for security review
CREATE INDEX IF NOT EXISTS idx_security_flags
  ON aao_audit_ledger(security_flag)
  WHERE security_flag = 1;

-- View for human-readable audit summary
CREATE VIEW IF NOT EXISTS aao_audit_summary AS
SELECT
  timestamp,
  session_id,
  action_name,
  risk_level,
  CASE user_confirmed WHEN 1 THEN 'Yes' ELSE 'No' END AS confirmed,
  CASE
    WHEN entry_type = 'rejected' THEN 'Rejected: ' || COALESCE(rejection_reason, 'unknown')
    WHEN rollback_triggered = 1 THEN 'Rolled back'
    WHEN health_check_passed = 1 THEN 'Success'
    WHEN health_check_passed = 0 THEN 'Health check failed'
    ELSE entry_type
  END AS outcome,
  user_query_context
FROM aao_audit_ledger
WHERE entry_type IN ('post_execution', 'rejected')
ORDER BY timestamp DESC;
