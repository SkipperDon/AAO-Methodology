# 03 — The Action Layer

## What the Action Layer Is

The Action Layer is the single, controlled interface between the AI system and any real-world action capability. It is the most critical component in an AAO implementation.

Everything the AI can do in the real world flows through the Action Layer. Nothing bypasses it.

---

## What the Action Layer Does

For every action request from the AI:

1. **Validates** the action name against the whitelist — unknown actions are rejected
2. **Validates** all parameters against the schema defined in the whitelist
3. **Checks** confirmation status — has the user confirmed if required?
4. **Takes a snapshot** of runtime state if the action's risk level requires it
5. **Writes a pre-execution audit entry** — the action is logged before it runs
6. **Executes** the action through the defined handler function
7. **Runs a health check** if the action's risk level requires it
8. **Triggers rollback** automatically if the health check fails
9. **Writes a post-execution audit entry** — the outcome is logged

No step can be skipped. The sequence is enforced by the Action Layer implementation, not by convention or trust.

---

## Implementation Pattern

```javascript
// action-layer.js — core implementation
const WHITELIST = JSON.parse(
  fs.readFileSync('/opt/app/base/action-whitelist.json')
);

async function executeAction(request, sessionId) {
  const { actionName, parameters, userConfirmed } = request;

  // Step 1: Validate action name
  const actionDef = WHITELIST[actionName];
  if (!actionDef) {
    await writeAuditLog('rejected', { actionName, reason: 'not_on_whitelist', sessionId });
    throw new Error(`Action not permitted: ${actionName}`);
  }

  // Step 2: Validate parameters
  validateParameters(parameters, actionDef.parameters);

  // Step 3: Check confirmation
  if (actionDef.requires_user_confirmation && !userConfirmed) {
    throw new Error(`User confirmation required for: ${actionName}`);
  }

  // Step 4: Take snapshot if required
  let snapshotId = null;
  if (actionDef.risk_level !== 'None') {
    snapshotId = await takeSnapshot(actionName);
  }

  // Step 5: Pre-execution audit log
  const logEntry = await writeAuditLog('pre_execution', {
    actionName, parameters, sessionId, snapshotId,
    riskLevel: actionDef.risk_level
  });

  // Step 6: Execute
  let result;
  try {
    result = await ACTION_HANDLERS[actionName](parameters);
  } catch (error) {
    await writeAuditLog('execution_failed', { ...logEntry, error: error.message });
    if (snapshotId) await rollback(snapshotId, 'execution_error');
    throw error;
  }

  // Step 7 & 8: Health check and auto-rollback
  let healthResult = null;
  if (actionDef.risk_level !== 'None') {
    healthResult = await runHealthCheck(actionDef.health_check_timeout_seconds);
    if (!healthResult.passed) {
      await rollback(snapshotId, 'health_check_failed');
    }
  }

  // Step 9: Post-execution audit log
  await writeAuditLog('post_execution', {
    ...logEntry, result, healthResult,
    rolledBack: healthResult && !healthResult.passed
  });

  return { result, healthResult, snapshotId };
}
```

---

## The Handler Registry

Each whitelisted action has a corresponding handler function. Handlers are registered at startup:

```javascript
const ACTION_HANDLERS = {
  restart_service: async ({ service_name }) => {
    // Validate service_name against allowed list
    const ALLOWED_SERVICES = ['signalk', 'mqtt-publisher', 'dashboard'];
    if (!ALLOWED_SERVICES.includes(service_name)) {
      throw new Error(`Service not in allowed list: ${service_name}`);
    }
    const result = await exec(`systemctl restart ${service_name}`);
    return { stdout: result.stdout, returncode: result.code };
  },

  read_system_logs: async ({ service_name, lines }) => {
    const result = await exec(
      `journalctl -u ${service_name} -n ${Math.min(lines, 200)} --no-pager`
    );
    return { logs: result.stdout };
  },

  set_config_value: async ({ key, value }) => {
    const CONFIG_RANGES = require('/opt/app/base/config-ranges.json');
    const range = CONFIG_RANGES[key];
    if (!range) throw new Error(`Config key not permitted: ${key}`);
    if (value < range.min || value > range.max) {
      throw new Error(`Value ${value} outside permitted range [${range.min}, ${range.max}]`);
    }
    fs.writeFileSync(`/opt/app/runtime/config/${key}.json`, JSON.stringify({ value }));
    return { key, value, previousValue: range.current };
  }
};
```

---

## Restricted Execution User

The Action Layer MUST run under a dedicated restricted user. This user has only the specific sudo permissions required for its defined actions — nothing more.

Example `/etc/sudoers.d/app-ai-action`:

```
# AAO Action Layer restricted permissions
app-ai-action ALL=(ALL) NOPASSWD: /bin/systemctl restart signalk
app-ai-action ALL=(ALL) NOPASSWD: /bin/systemctl restart mqtt-publisher
app-ai-action ALL=(ALL) NOPASSWD: /sbin/ip link set can0 down
app-ai-action ALL=(ALL) NOPASSWD: /sbin/ip link set can0 up type can bitrate *
```

Any attempt to execute a command not in this sudoers file is blocked at the OS level — not just at the application level. This is the final enforcement layer that prompt injection cannot bypass.

---

## Why the Action Layer Must Be Built First

A common implementation mistake is building the AI integration first and adding the Action Layer later. This is backwards.

If you build the AI integration first, you will likely create direct execution paths for convenience during development. Those paths accumulate technical debt that is difficult to remove. The Action Layer ends up as a wrapper around existing direct execution rather than the sole execution path.

Build the Action Layer first. Test it completely — including rejected action tests and rollback tests. Only then integrate the AI. With the Action Layer in place, the AI integration is constrained to use it from the beginning.

---

*[Back: 02 — Immutable Base](02-immutable-base.md) | [Next: 04 — Audit Trail](04-audit-trail.md)*
