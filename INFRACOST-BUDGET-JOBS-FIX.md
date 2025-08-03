# Fix: Conditions for Budget Monitoring and Monthly Cost Summary Jobs

## Problem Identified
The `budget-alerts` and `infracost-summary` jobs were being skipped because they had restrictive conditions:

```yaml
if: github.event_name == 'push' && github.ref == 'refs/heads/main'
```

This condition meant they would **only run** when:
1. Event is a `push` (not `pull_request`)
2. Target branch is `main`

## Current Scenario
- We're working with a **Pull Request** from `setup` to `main`
- Event type: `pull_request` (not `push`)
- Target branch: `main` (but condition was checking source branch)

## Solution Implemented
Modified the conditions to also run on Pull Requests targeting main:

```yaml
if: (github.event_name == 'push' && github.ref == 'refs/heads/main') || (github.event_name == 'pull_request' && github.event.pull_request.base.ref == 'main')
```

### New Logic:
- **✅ Push to main**: `github.event_name == 'push' && github.ref == 'refs/heads/main'`
- **✅ PR to main**: `github.event_name == 'pull_request' && github.event.pull_request.base.ref == 'main'`

## Jobs Modified
1. **`infracost-summary`**: Monthly Cost Summary job
2. **`budget-alerts`**: Budget Monitoring job

## Expected Behavior
Both jobs should now execute during Pull Requests that target the `main` branch, providing cost analysis and budget monitoring even during the review process.

## Benefits
- Cost analysis available during PR review
- Budget alerts triggered before merging
- Complete workflow execution for better testing
- Early detection of cost impacts
