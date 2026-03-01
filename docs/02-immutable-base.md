# 02 — Immutable Base Architecture

## The Core Guarantee

The immutable base is the foundation that makes everything else in AAO trustworthy. It provides one guarantee that no other component in the system can provide:

**No matter what the AI does, the application code is always in a known state.**

This guarantee is what makes the factory reset meaningful. It is what makes audit trail entries trustworthy — the system that logged an action is the system whose code has not changed. It is what makes the action whitelist enforceable — the whitelist on the immutable base cannot be modified by the AI to expand its own permissions.

---

## What Belongs in the Base

The base partition contains everything that defines how the system works — as opposed to how it is currently configured:

- Application code for all system components and services
- Service definitions (systemd units or equivalent)
- The action whitelist definition file
- Health check, snapshot, and rollback scripts used by the Action Layer
- Cryptographic public keys used for update verification
- The AI system prompt (cannot be modified at runtime)

What does NOT belong in the base:
- User configuration (belongs in runtime layer)
- Logs (belong in runtime layer)
- User data (belongs in a separate data partition)
- Credentials or secrets (belong in a secrets management system)

---

## Implementation

### Partition Mounting

The base partition is mounted read-only at boot via fstab or equivalent:

```
/dev/mmcblk0p2  /opt/app/base  ext4  ro,defaults  0  2
```

The `ro` flag makes the partition read-only for all processes at the OS level. This cannot be overridden by application code running as a normal user.

### Integrity Verification

On boot, compute a hash of the base partition and compare it to a stored expected hash:

```bash
#!/bin/bash
# base-integrity-check.sh — runs on boot
EXPECTED=$(cat /opt/app/base/.expected-hash)
ACTUAL=$(find /opt/app/base -type f -exec sha256sum {} \; | sort | sha256sum | awk '{print $1}')

if [ "$ACTUAL" != "$EXPECTED" ]; then
  echo "BASE_INTEGRITY_FAIL: partition has been modified"
  # Suspend AI action capability
  touch /opt/app/runtime/flags/ai-actions-suspended
  # Alert operator
  systemctl start base-integrity-alert.service
  exit 1
fi

echo "BASE_INTEGRITY_OK"
```

### Updating the Base

The only permitted modification path to the base partition is a signed update package:

```bash
# Verify signature
openssl dgst -sha256 -verify /opt/app/base/keys/updates.pub \
  -signature package.sig package.tar.gz

# Temporarily remount read-write
mount -o remount,rw /opt/app/base

# Apply update
tar -xzf package.tar.gz -C /opt/app/base/

# Update expected hash
find /opt/app/base -type f -exec sha256sum {} \; | sort | sha256sum \
  > /opt/app/base/.expected-hash

# Remount read-only
mount -o remount,ro /opt/app/base
```

---

## The Signing Key Architecture

The update signing private key is the most critical security asset in the system. If it is compromised, an attacker can deliver arbitrary code to every installation.

**Private key:** Stored only on the build/release server. Never in the repository. Never in the database. Ideally in a hardware security module (HSM) or encrypted secrets manager.

**Public key:** Stored in the base partition at `/opt/app/base/keys/updates.pub`. Since it is in the immutable base, it cannot be replaced at runtime. The only way to rotate the public key is through a signed update package — which requires the current private key.

**Key rotation:** Document the rotation procedure before the system goes to production. You cannot rotate the key in an emergency if you have never done it in a controlled setting.

---

## What This Means for the AI

With an immutable base in place, the following properties hold regardless of what the AI does:

1. The action whitelist cannot be modified by the AI — it cannot expand its own permissions
2. The health check scripts cannot be modified — rollback logic is always intact
3. The audit logging code cannot be modified — the ledger cannot be corrupted
4. The system prompt cannot be modified — the AI's defined role is always enforced
5. A factory reset always produces a known clean state

These are not promises that depend on the AI behaving correctly. They are structural guarantees.

---

*[Back to README](../README.md) | [Next: 03 — The Action Layer](03-action-layer.md)*
