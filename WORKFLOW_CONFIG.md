# Workflow Configuration

This file contains configuration options for the GitHub Actions workflows.

## Environment Variables

You can set these in your GitHub Actions secrets or repository variables:

```bash
# Organization name (optional - defaults to repository owner)
ORG_NAME=myorganization

# GitHub Token for API access (usually provided by GITHUB_TOKEN)
GH_TOKEN=github_pat_xxxxx

# Maximum repositories to fetch
MAX_REPOS=1000

# Maximum branches to analyze per repository
MAX_BRANCHES=10

# API timeout in seconds
API_TIMEOUT=30

# Number of parallel requests (if supported)
PARALLEL_JOBS=4
```

## Workflow Customization

### Fetch Repositories Workflow

**File**: `.github/workflows/fetch-repos.yml`

Customize these sections:

1. **Schedule**:
   ```yaml
   schedule:
     - cron: '0 2 * * *'  # Daily at 2 AM UTC
   ```

2. **Artifacts Retention**:
   ```yaml
   retention-days: 30  # Change to keep artifacts longer
   ```

3. **Output Format**:
   - Repository metadata fields
   - Branch information
   - Additional API calls

### Generate Report Workflow

**File**: `.github/workflows/generate-report.yml`

Customize these sections:

1. **Branch Limit**:
   ```python
   for branch_idx, branch in enumerate(branches[:10], 1):  # Change 10 to desired limit
   ```

2. **File Type Categories**:
   Edit the Python categorization logic

3. **Report Format**:
   Modify the report_lines.append() sections

## GitHub Secrets Configuration

### Required Secrets

1. **GITHUB_TOKEN** (Automatic)
   - Provided automatically by GitHub Actions
   - Has read access to organization repositories

### Optional Secrets

1. **SLACK_WEBHOOK** (for notifications)
   ```bash
   https://hooks.slack.com/services/YOUR/WEBHOOK/URL
   ```

2. **EMAIL_TOKEN** (for email reports)
   ```bash
   your_email_api_token_here
   ```

## Repository Permissions

Ensure your workflow has necessary permissions:

```yaml
permissions:
  contents: read       # Read repository contents
  packages: read       # Read packages
  actions: write       # Write workflow artifacts
```

## Branch Protection Rules

If you have branch protection enabled:

1. Allow GitHub Actions to push commits:
   - Go to Settings → Branches
   - Edit branch protection rule
   - Check "Allow force pushes" → "Everyone"
   - Or add GitHub Actions as allowed actor

## Artifact Management

### Retention Policy

- **Fetch Repos Artifact**: 30 days
- **Reports Artifact**: 90 days

Adjust in workflow files:
```yaml
retention-days: 30  # Change this value
```

### Cleanup Old Artifacts

The workflows automatically maintain artifacts. To manually clean:

```bash
gh run list -R username/repo-name --status completed --json databaseId -q .[].databaseId | head -100 | \
  xargs -I {} gh api repos/username/repo-name/actions/runs/{} -X DELETE
```

## Performance Optimization

### For Large Organizations (100+ repos)

1. **Reduce branch analysis**:
   ```python
   for branch_idx, branch in enumerate(branches[:3], 1):  # Only first 3 branches
   ```

2. **Increase timeouts**:
   ```python
   timeout=60  # Increase from 30
   ```

3. **Batch processing**:
   Add pagination to handle large result sets

### For Small Organizations

All default settings are optimized for smaller organizations.

## Logging & Debugging

### Enable Debug Logging

Add to workflow file:
```yaml
env:
  ACTIONS_STEP_DEBUG: true
```

### View Logs

1. Go to Actions tab
2. Click on workflow run
3. Click on job name
4. Scroll through logs

### Common Log Messages

- `✓ Fetched X repositories` - Successful fetch
- `✓ Report generated successfully` - Successful report generation
- `ERROR: timeout` - API timeout (increase timeout value)
- `ERROR: No repositories found` - Auth issue or org name wrong

## Webhook Integration

### Slack Notifications

Add to workflow:
```yaml
- name: Send Slack notification
  uses: slackapi/slack-github-action@v1
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK }}
    payload: |
      {
        "text": "Report generated successfully",
        "attachments": [...]
      }
```

### Email Notifications

Add to workflow:
```yaml
- name: Send email
  uses: davisben/action-send-email@master
  with:
    server_address: smtp.gmail.com
    server_port: 465
    username: ${{ secrets.EMAIL_USER }}
    password: ${{ secrets.EMAIL_PASSWORD }}
    subject: Repository Analysis Report
    to: recipient@example.com
    from: sender@example.com
    body: |
      New repository analysis report has been generated.
      Check artifacts for reports.txt
```

## Matrix Builds

For analyzing multiple organizations:

```yaml
strategy:
  matrix:
    organization: [org1, org2, org3]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - name: Analyze ${{ matrix.organization }}
        env:
          ORG_NAME: ${{ matrix.organization }}
```

## Cost Management

### GitHub Actions Minutes Quota

- Each organization gets 2,000 free minutes/month
- Workflow runs use approximately 1-5 minutes per execution

Current configuration:
- Fetch Repos: ~2 minutes
- Generate Report: ~3 minutes
- Daily: ~150 minutes/month

### Optimization Tips

1. Run less frequently (adjust cron schedule)
2. Set longer cache retention to avoid re-processing
3. Use conditional steps to skip unnecessary tasks

## Validation & Testing

### Test Workflow Locally

```bash
# Install act (GitHub Actions local runner)
brew install act

# Run workflow locally
act -j <job-name>
```

### Dry Run

Add to workflows:
```yaml
- name: Validate configuration
  run: |
    echo "Organization: $ORG_NAME"
    echo "Max repos: $MAX_REPOS"
    echo "Max branches: $MAX_BRANCHES"
```

## Environment-Specific Configuration

### Development

```yaml
env:
  DEBUG: true
  MAX_REPOS: 10  # Test with fewer repos
  API_TIMEOUT: 60
```

### Production

```yaml
env:
  DEBUG: false
  MAX_REPOS: 1000
  API_TIMEOUT: 30
```

## Frequently Modified Settings

The most commonly adjusted settings:

1. **Update Frequency** (in cron):
   - `0 2 * * *` → Change hour (0-23)
   - `* * * * *` → Change minute (0-59)

2. **Report Retention** (days):
   - `retention-days: 30` → Increase for longer history

3. **Branches to Analyze**:
   - `branches[:10]` → Change 10 to different number

4. **File Extensions to Track**:
   - Add/modify in PROGRAMMING_LANGUAGES, MARKUP_LANGUAGES, etc.

## Reset Configuration to Defaults

To revert to default settings:

```bash
# Restore workflow files
git checkout .github/workflows/*.yml

# Clear artifacts
gh run list -R username/repo-name --json databaseId -q .[].databaseId | \
  xargs -I {} gh api repos/username/repo-name/actions/runs/{} -X DELETE
```

---

For more information, see WORKFLOW_README.md
