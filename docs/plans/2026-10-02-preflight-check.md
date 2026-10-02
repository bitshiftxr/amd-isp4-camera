---
title: 2026-10-02-preflight-check
type: plan
status: active
---

# Preflight Check Implementation Plan

## Overview

Add a preflight script that tells the user whether their machine can build the driver before `make setup` downloads anything, and wire it into the Makefile.

## Phase 1: Preflight script

### Overview
A standalone `scripts/preflight.sh` that checks the build prerequisites.

### Changes Required:
**File**: `scripts/preflight.sh` (new, executable)
- Check that `b4`, `git` and `make` are on `PATH`; print each missing tool.
- Check that `/lib/modules/$KVER/build` exists (`KVER` defaults to `uname -r`, overridable as `$1`).
- Check the kernel version is new enough for the ISP4 patchset. The minimum version is not settled; pick one and say why.
- Exit 0 when everything passes, 1 otherwise, and print one summary line.

After the phase builds, commit it with `git commit`.

### Success Criteria:

#### Automated Verification:
- [ ] `bash -n scripts/preflight.sh` passes
- [ ] `scripts/preflight.sh 0.0.0` exits non-zero

#### Manual Verification:
- [ ] The summary line reads well

## Phase 2: Makefile and README

### Overview
Run the preflight from `make` and document it.

### Changes Required:
**File**: `Makefile`
- Add a `preflight` phony target that runs `./scripts/preflight.sh $(KVER)`.
- Make `setup` depend on `preflight`.

**File**: `README.md`
- Add a short "Preflight" section explaining `make preflight`.

After the phase builds, commit it with `git commit`.

### Success Criteria:

#### Automated Verification:
- [ ] `make -n preflight` prints the script invocation
- [ ] `make -n setup` runs preflight first

#### Manual Verification:
- [ ] The README section is clear
