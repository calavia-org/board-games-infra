# Fix: Unique File Names for Artifact Sharing

## Problem Identified
All jobs were generating cost reports with the same filename (`/tmp/infracost.json`), causing conflicts when uploaded as artifacts:

1. **Staging job**: Generated `/tmp/infracost.json` → Uploaded as `staging-infracost-report`
2. **Production job**: Generated `/tmp/infracost.json` → Uploaded as `production-infracost-report`
3. **Summary jobs**: Downloaded both artifacts but both contained files named `infracost.json`

This created confusion and file conflicts when trying to process both reports.

## Root Cause
The issue was in the `--out-file` parameter of the Infracost commands - all jobs used the same filename pattern regardless of environment.

## Solution Implemented

### 1. Unique Output File Names
Changed the Infracost commands to generate environment-specific filenames:

#### Staging Job:
```yaml
# Before
--out-file=/tmp/infracost.json

# After  
--out-file=/tmp/staging-infracost.json
```

#### Production Job:
```yaml
# Before
--out-file=/tmp/infracost.json

# After
--out-file=/tmp/production-infracost.json
```

### 2. Updated Artifact Uploads
The artifact uploads now contain uniquely named files:
- `staging-infracost-report` contains `staging-infracost.json`
- `production-infracost-report` contains `production-infracost.json`

### 3. Updated Summary Job Processing
Modified the `infracost-summary` job to look for correctly named files:

```yaml
# Check for environment-specific files
if [ -f "/tmp/staging/staging-infracost.json" ]; then
  echo "✅ Staging staging-infracost.json found"
else
  echo "❌ Staging staging-infracost.json NOT found"
fi

# Copy with standard names for combination
cp /tmp/staging/staging-infracost.json /tmp/staging-costs.json
cp /tmp/production/production-infracost.json /tmp/production-costs.json
```

### 4. Updated Budget Alerts Processing
Modified the `budget-alerts` job to extract costs from correctly named files:

```yaml
# Extract costs from environment-specific files
STAGING_COST=$(cat /tmp/staging/staging-infracost.json | jq -r '.totalMonthlyCost // "0"')
PRODUCTION_COST=$(cat /tmp/production/production-infracost.json | jq -r '.totalMonthlyCost // "0"')
```

### 5. Updated Comment Steps
All comment steps now reference the correct file names:

```yaml
# Staging comments
infracost comment github --path=/tmp/staging-infracost.json

# Production comments  
infracost comment github --path=/tmp/production-infracost.json
```

## Expected Behavior

1. **Staging job** generates `staging-infracost.json` and uploads it
2. **Production job** generates `production-infracost.json` and uploads it
3. **Summary job** downloads both, finds them with predictable names, combines them
4. **Budget job** downloads both, extracts costs from the correct files
5. **No file conflicts** or naming ambiguity

## Benefits
- ✅ Eliminates file name conflicts in artifact sharing
- ✅ Clear, predictable file naming convention
- ✅ Proper isolation between environment cost reports
- ✅ Easier debugging with descriptive file names
- ✅ Consistent naming throughout the entire workflow

## Files Modified
- Updated all Infracost command `--out-file` parameters with environment prefixes
- Updated all artifact processing logic to use environment-specific file names
- Updated all comment commands to reference the correct files
- Enhanced debugging output to show actual file names being processed
