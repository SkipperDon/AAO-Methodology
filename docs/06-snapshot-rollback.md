# 06 — Snapshot and Rollback

## The Recovery Guarantee

The snapshot and rollback system provides one guarantee that matters above all others: no matter what the AI does, the system can be returned to a working state.

This guarantee is what enables the AI to have meaningful action capability without the risk of irreversible damage. An action that might break something is acceptable if recovery is guaranteed. An action that might permanently break something is not acceptable regardless of its potential benefit.

---

## What Gets Snapshotted

A snapshot captures the complete runtime state before a consequential action:

```bash
#!/bin/bash
# take-snapshot.sh
SNAPSHOT_ID="snap-$(date +%Y%m%d%H%M%S)-$(uuidgen | head -c 8)"
SNAPSHOT_DIR="/opt/app/snapshots/${SNAPSHOT_ID}"

mkdir -p "$SNAPSHOT_DIR"

# 1. Runtime configuration
cp -r /opt/app/runtime/config/ "$SNAPSHOT_DIR/config/"

# 2. Service states
systemctl list-units 'app-*' --state=active --no-legend \
  | awk '{print $1}' > "$SNAPSHOT_DIR/active-services.txt"

# 3. Snapshot metadata
cat > "$SNAPSHOT_DIR/meta.json" << METAEOF
{
  "snapshot_id": "${SNAPSHOT_ID}",
  "triggered_by_action": "${1}",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)",
  "app_version": "$(cat /opt/app/version)"
}
METAEOF

# 4. Prune old snapshots — keep last 10
ls -dt /opt/app/snapshots/snap-* | tail -n +11 | xargs rm -rf 2>/dev/null

echo "$SNAPSHOT_ID"
```

---

## The Health Check

The health check verifies the system is in a working state after an action:

```bash
#!/bin/bash
# health-check.sh — stored in immutable base, cannot be modified at runtime
TIMEOUT=${1:-60}
DEADLINE=$(($(date +%s) + TIMEOUT))
SNAPSHOT_SERVICES=$(cat "$2" 2>/dev/null || echo "")

while [ "$(date +%s)" -lt "$DEADLINE" ]; do
  sleep 5
  FAILED=0

  # Check each service that was running before the action
  while read -r service; do
    if ! systemctl is-active --quiet "$service" 2>/dev/null; then
      FAILED=$((FAILED + 1))
    fi
  done <<< "$SNAPSHOT_SERVICES"

  if [ "$FAILED" -eq 0 ]; then
    echo '{"passed": true, "checked_at": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}'
    exit 0
  fi
done

echo '{"passed": false, "failed_services": '${FAILED}', "timeout_seconds": '${TIMEOUT}'}'
exit 1
```

---

## Automatic Rollback

When the health check fails, rollback executes immediately without waiting for human input:

```bash
#!/bin/bash
# rollback.sh — stored in immutable base
SNAPSHOT_ID=$1
SNAPSHOT_DIR="/opt/app/snapshots/${SNAPSHOT_ID}"
REASON=$2

echo "ROLLBACK_STARTED: $SNAPSHOT_ID reason=$REASON"

# 1. Restore configuration
cp -r "$SNAPSHOT_DIR/config/" /opt/app/runtime/config/

# 2. Restart services to previous state
systemctl restart app-\* 2>/dev/null

# 3. Wait and verify
sleep 15
SECOND_CHECK=$(bash /opt/app/base/scripts/health-check.sh 30 "$SNAPSHOT_DIR/active-services.txt")

if echo "$SECOND_CHECK" | grep -q '"passed": true'; then
  echo "ROLLBACK_SUCCESSFUL"
  exit 0
else
  echo "ROLLBACK_FAILED: $SECOND_CHECK"
  # Critical state — alert operator
  touch /opt/app/runtime/flags/critical-state
  exit 1
fi
```

---

## Manual Rollback

The user must be able to manually trigger rollback at any time. Provide:

1. An "Undo last action" shortcut that restores the most recent snapshot
2. A snapshot browser showing all available snapshots with timestamps and triggering actions
3. The ability to say to the AI "undo what you just did" — the AI calls `restore_snapshot` through the Action Layer

---

## Retention and Pruning

Keep the last 10 snapshots. Prune automatically after each new snapshot is taken.

10 snapshots is sufficient for most recovery scenarios while keeping storage manageable. If a user needs to recover from further back than 10 actions ago, they use the factory reset path to the immutable base.

---

## The Factory Reset Path

When snapshots are insufficient — the SD card is corrupt, the Pi is physically damaged, recovery from snapshot fails — the immutable base provides the final recovery path.

Factory reset:
1. Wipe the runtime partition completely
2. The base partition is untouched — application code intact
3. User runs the setup wizard again
4. Configuration is restored from the remote backup if available
5. System returns to working state

This path always works because the base is immutable. The AI cannot corrupt the base. Updates cannot corrupt the base unless the signing key is compromised. Hardware failure that corrupts the runtime partition does not affect the base.

---

---

## 6.4 Interactive Development Mode — Git as Snapshot Layer

When Claude Code operates as an interactive development tool (not a deployed
autonomous agent), the Layer 3 Action Layer and its automated snapshot infrastructure
are not present. This subsection defines how the snapshot guarantee is maintained
in that context.

See **SPECIFICATION.md Section 17** for the complete normative requirements.

### Summary

| Production Autonomous Agent | Interactive Development Tool |
|---|---|
| Action Layer takes snapshot automatically | Operator ensures clean git working tree |
| Health check triggers auto-rollback | Operator reviews changes before committing |
| Rollback restores from snapshot | `git checkout` or `git restore` against last commit |
| Audit ledger records all actions | Session log + git history |

### The Non-Negotiable Rule

**If the working tree is not clean at session start, Claude Code must stop.**

A dirty working tree means uncommitted changes exist. If Claude Code modifies
those files, the prior state is permanently lost — there is no snapshot to roll
back to.

This is the single most common cause of unrecoverable state in Interactive
Development Mode. It must be checked before every session, every time.

### Pre-Edit Snapshot Protocol

```
1. git status → must be clean before proceeding
2. Confirm exact files in scope for this session
3. Checkpoint commit required before structural file edits
4. Operator reviews file-change summary before commit
5. No push without separate explicit operator instruction
```

See CLAUDE.md — Pre-Edit Snapshot Rule for the governing instruction.

---

*[Back: 05 — Prompt Injection](05-prompt-injection.md) | [Next: 07 — SDLC Integration](07-sdlc-integration.md)*
