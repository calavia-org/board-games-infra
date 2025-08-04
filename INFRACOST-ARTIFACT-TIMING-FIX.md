# Fix: Artifact Upload Timing and Enhanced Debugging

## Problem Identified
The monthly report and budget monitoring jobs were failing to find artifacts, likely due to:

1. **Upload Timing**: Artifacts were uploaded after comment steps, which could fail
2. **Missing Debugging**: Limited visibility into what files are actually available
3. **Error Handling**: No validation that required files exist before processing

## Root Causes
- If comment steps failed, artifacts might not be uploaded
- Artifact uploads were positioned after potentially failing steps
- No clear debugging information about artifact availability

## Solution Implemented

### 1. Moved Artifact Upload Earlier
Moved the artifact upload steps immediately after the cost analysis generation:

#### Before (Problematic):
```yaml
- name: Generate Infracost diff
- name: Post Infracost comment          # ❌ Could fail
- name: Upload staging cost report      # ❌ Might not execute
- name: Post Infracost comment (commit) # ❌ Could fail
```

#### After (Fixed):
```yaml
- name: Generate Infracost diff
- name: Upload staging cost report      # ✅ Executes immediately
- name: Post Infracost comment          # ✅ Can fail without affecting artifacts
- name: Post Infracost comment (commit) # ✅ Can fail without affecting artifacts
```

### 2. Enhanced Debugging for Summary Job
Added comprehensive debugging to `infracost-summary`:

```yaml
- name: Generate combined cost report
  run: |
    echo "=== DEBUGGING ARTIFACT DOWNLOADS ==="
    echo "Staging files:"
    ls -la /tmp/staging/ || echo "Staging directory not found"
    
    if [ -f "/tmp/staging/infracost.json" ]; then
      echo "✅ Staging infracost.json found"
      echo "Staging file size: $(wc -c < /tmp/staging/infracost.json) bytes"
    else
      echo "❌ Staging infracost.json NOT found"
    fi
```

### 3. Enhanced Debugging for Budget Alerts
Added validation and debugging to `budget-alerts`:

```yaml
- name: Check budget thresholds
  run: |
    echo "=== DEBUGGING BUDGET ALERTS ARTIFACTS ==="
    
    if [ -f "/tmp/staging/infracost.json" ]; then
      echo "✅ Staging artifact found"
    else
      echo "❌ Staging artifact missing"
      exit 1  # Fail fast if artifacts are missing
    fi
```

### 4. Proper Job Dependencies
Ensured both summary jobs depend on the cost analysis jobs:

```yaml
infracost-summary:
  needs: [infracost-staging, infracost-production]  # ✅ Already had this

budget-alerts:
  needs: [infracost-staging, infracost-production]  # ✅ Added in previous fix
```

## Expected Behavior

1. **Cost Analysis Jobs**: Generate reports → Upload artifacts immediately → Try to post comments
2. **Summary Jobs**: Wait for artifacts → Download with debugging → Process with validation
3. **Failure Isolation**: Comment failures don't prevent artifact sharing

## Benefits
- ✅ Artifacts uploaded regardless of comment step success
- ✅ Comprehensive debugging for troubleshooting
- ✅ Fast failure if required artifacts are missing
- ✅ Better visibility into workflow execution
- ✅ More resilient artifact sharing

## Files Modified
- Moved artifact upload steps earlier in both `infracost-staging` and `infracost-production`
- Added extensive debugging to both summary jobs
- Added validation to prevent processing with missing artifacts
