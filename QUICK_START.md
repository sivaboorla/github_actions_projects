# Quick Start Guide

Get your GitHub Organization Repository Analysis up and running in 5 minutes!

## 🚀 5-Minute Setup

### Step 1: Prepare Your Repository (1 min)

Make sure the following files are in your repository:
- ✅ `.github/workflows/fetch-repos.yml`
- ✅ `.github/workflows/generate-report.yml`
- ✅ `scripts/analyze_repos.py`
- ✅ `scripts/analyze.sh`

All files should already be present in this repository.

### Step 2: Enable GitHub Actions (1 min)

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Actions** → **General**
3. Ensure GitHub Actions is enabled
4. Set "Allow all actions and reusable workflows"

### Step 3: Push to Repository (1 min)

```bash
git add .
git commit -m "Add GitHub organization analyzer workflows"
git push origin main
```

### Step 4: Trigger the First Workflow (1 min)

1. Go to your repository home
2. Click **Actions** tab
3. Select **Fetch Repositories** workflow
4. Click **Run workflow** button
5. Select **Run workflow** from dropdown

### Step 5: View Results (1 min)

1. Wait for both workflows to complete
2. Go to **Actions** tab
3. Click on the most recent run
4. Download artifacts:
   - `repositories-json` → Contains `repositories.json`
   - `reports` → Contains `reports.txt`

**Done!** ✅

---

## 📊 Understanding Your Report

### Key Sections

The `reports.txt` file contains:

1. **Organization Overview**
   - Number of repositories
   - Public vs Private count

2. **Per-Repository Details**
   - Repository metadata
   - File statistics
   - Storage usage
   - File type breakdown

3. **Global Summary**
   - Total files across organization
   - Storage usage totals
   - Top file types

### Example Interpretation

```
Total Files: 15,234
Total Size: 2.45 GB

Top File Types:
- JavaScript: 4,232 files (1.2 GB)
- Python: 3,145 files (320 MB)
- JSON: 2,890 files (145 MB)
```

This tells you:
- Organization has lots of JS projects
- Second-largest codebase is Python
- Lots of configuration/data files

---

## 🔄 Running Locally

### Option 1: Using the Shell Script (Recommended)

```bash
# Basic usage
./scripts/analyze.sh -o your-org-name

# With custom output
./scripts/analyze.sh -o your-org-name -f my_report.txt
```

### Option 2: Using Python Directly

```bash
cd scripts
python3 analyze_repos.py your-org-name
```

### Prerequisites for Local Run

```bash
# Install GitHub CLI
brew install gh  # macOS
sudo apt install gh  # Ubuntu

# Authenticate
gh auth login

# Verify
gh repo list --limit 1
```

---

## ⏰ Scheduling

### Default Schedule

The workflows run automatically:
- **Daily at 2 AM UTC**

### Change Schedule

Edit `.github/workflows/fetch-repos.yml`:

```yaml
schedule:
  - cron: '0 2 * * *'  # Change the numbers
         ↑ ↑ ↑ ↑ ↑
         │ │ │ │ │
         │ │ │ │ day of week (0-6, Sunday=0)
         │ │ │ month (1-12)
         │ │ day of month (1-31)
         │ hour (0-23)
         minute (0-59)
```

**Common Schedules:**
- Every 6 hours: `0 */6 * * *`
- Weekly (Sunday): `0 0 * * 0`
- Monthly (1st): `0 0 1 * *`
- Every 30 mins: `*/30 * * * *`

---

## 🐛 Quick Troubleshooting

### Issue: "Repository not found"

**Cause**: Organization name is incorrect

**Fix**: 
```bash
# Check organization name
gh org list
```

### Issue: "Access Denied" or "Authentication failed"

**Cause**: GitHub token doesn't have permission

**Fix**:
```bash
# Re-authenticate
gh auth logout
gh auth login

# Choose token with org:read permission
```

### Issue: Workflows don't trigger automatically

**Cause**: GitHub Actions not enabled

**Fix**:
- Settings → Actions → General
- Enable GitHub Actions
- Set to "Allow all actions"

### Issue: "No files found" in report

**Cause**: Repository might be empty or private

**Fix**:
- Verify repository is accessible
- Check if repository has any commits
- Verify GitHub token has access

---

## 📈 Common Use Cases

### Use Case 1: Monitor Organization Growth

Run the analyzer monthly and compare reports to track:
- New repositories created
- Code growth
- Language adoption

### Use Case 2: Project Health Check

Review file statistics to understand:
- Project complexity (by file count)
- Memory footprint (by storage size)
- Code organization (by file types)

### Use Case 3: Technology Stack Analysis

Aggregate file types across organization to see:
- Most used programming languages
- Configuration file popularity
- Documentation coverage

### Use Case 4: Storage Planning

Track total storage used to:
- Forecast capacity needs
- Optimize large repos
- Identify storage hogs

---

## 🎯 Next Steps

After successful first run:

1. ✅ **Review the Report**
   - Check findings
   - Understand your organization's structure

2. ✅ **Archive Reports**
   - Download reports.txt
   - Save to external storage
   - Track changes over time

3. ✅ **Customize Settings**
   - Adjust scheduling frequency
   - Modify file type categories
   - Add custom metrics

4. ✅ **Integrate with Other Tools**
   - Export to Slack
   - Send via email
   - Store in cloud storage

5. ✅ **Set Alerts** (Optional)
   - Create GitHub issues for large repos
   - Notify teams of changes
   - Track metrics over time

---

## 💡 Pro Tips

### Tip 1: Compare Reports Over Time

```bash
# Save reports with timestamps
cp reports.txt reports_$(date +%Y-%m-%d).txt

# Compare two reports
diff reports_2024-01-01.txt reports_2024-02-01.txt
```

### Tip 2: Extract Specific Data

```bash
# Find all repositories with specific language
grep -A 10 "JavaScript" reports.txt

# Count total files in Python projects
grep "\.py " reports.txt | wc -l
```

### Tip 3: Automated Report Distribution

Add to your workflow to email reports:
```yaml
- name: Email report
  uses: davisben/action-send-email@master
  with:
    to: team@example.com
    subject: "Monthly Org Report"
    body: "See attached report"
```

### Tip 4: Manual Backup

```bash
# Backup both JSON and report
mkdir -p backups
cp repos/repositories.json backups/repos_$(date +%Y-%m-%d).json
cp reports.txt backups/report_$(date +%Y-%m-%d).txt
git add backups/
git commit -m "Backup reports"
git push
```

---

## 📞 Getting Help

### Check Workflow Logs

1. Go to **Actions** tab
2. Click failing workflow
3. Click job name
4. Scroll through logs
5. Look for error messages

### Common Error Patterns

| Error | Solution |
|-------|----------|
| `Command not found: gh` | Install GitHub CLI |
| `Authentication failed` | Run `gh auth login` |
| `Organization not found` | Verify org name |
| `API rate limit` | Wait 1 hour and retry |
| `Timeout` | Increase timeout in config |

---

## 🎓 Learn More

- **GitHub CLI**: https://cli.github.com/manual
- **GitHub Actions**: https://github.com/features/actions
- **GitHub API**: https://docs.github.com/en/rest

---

## ✨ What's Included

You now have:

```
✅ Automated repository fetching workflow
✅ Advanced analysis and reporting workflow
✅ Python analyzer scripts
✅ Shell script wrappers
✅ Comprehensive documentation
✅ Configuration examples
✅ Quick start guide
```

**Start analyzing your organization now!** 🚀

---

**Version**: 1.0.0  
**Last Updated**: 2024-01-20
