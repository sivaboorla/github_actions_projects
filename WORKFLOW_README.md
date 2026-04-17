# GitHub Organization Repository Analyzer

This project provides a complete end-to-end solution to analyze all repositories in a GitHub organization and generate comprehensive reports about file statistics, sizes, types, and more.

## 📋 Overview

The solution consists of two main GitHub Actions workflows:

1. **Fetch Repositories Workflow** (`fetch-repos.yml`): Fetches all repositories and their branches from your GitHub organization and saves them to a JSON file
2. **Generate Report Workflow** (`generate-report.yml`): Processes the repositories JSON file and generates a detailed analysis report with file statistics

## 🏗️ Architecture

### Data Flow

```
┌─────────────────────────────────┐
│   GitHub Organization           │
│   (All Repositories)            │
└────────────────┬────────────────┘
                 │
                 ▼
        ┌─────────────────┐
        │ Fetch Repos     │
        │ Workflow        │
        └────────┬────────┘
                 │
                 ▼
        ┌─────────────────┐
        │ repos/          │
        │ repositories.   │
        │ json (Artifact) │
        └────────┬────────┘
                 │
                 ▼
        ┌─────────────────┐
        │ Generate Report │
        │ Workflow        │
        └────────┬────────┘
                 │
                 ▼
        ┌─────────────────┐
        │ reports.txt     │
        │ (Final Report)  │
        └─────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- GitHub account with organization access
- Repository with GitHub Actions enabled
- `gh` CLI installed (for local execution)
- Python 3.7+ installed (for local execution)

### Setup

1. **Clone this repository** (if not already done)
   ```bash
   git clone <repository-url>
   cd github_actions_projects
   ```

2. **Enable GitHub Actions** (if not already enabled)
   - Go to your repository settings
   - Navigate to "Actions" → "General"
   - Enable "Allow all actions and reusable workflows"

3. **Create necessary directories**
   ```bash
   mkdir -p repos scripts
   ```

4. **Make scripts executable**
   ```bash
   chmod +x scripts/analyze.sh
   ```

## 🔄 Using GitHub Actions Workflows

### Method 1: Manual Trigger (Recommended for Testing)

1. Go to your repository home page
2. Click on **"Actions"** tab
3. Find **"Fetch Repositories"** workflow
4. Click **"Run workflow"** button
5. This will automatically trigger the report generation workflow

### Method 2: Scheduled Execution

The workflows are configured to run on a schedule:
- **Fetch Repositories**: Daily at 2 AM UTC
- **Generate Report**: Automatically after Fetch Repositories completes

### Method 3: Manual Trigger with Specific Organization

To analyze a different organization:
1. Edit the workflow files to update `github.repository_owner` if needed
2. Or push changes to trigger the workflows

## 📊 Output Files

### `repos/repositories.json`
Contains metadata for all repositories:
```json
[
  {
    "name": "repo-name",
    "owner": {"login": "owner-name"},
    "url": "https://github.com/...",
    "isPrivate": false,
    "description": "Repository description",
    "createdAt": "2023-01-15T10:30:00Z",
    "updatedAt": "2024-01-20T15:45:00Z",
    "branches": [
      {"name": "main", "oid": "abc123..."},
      {"name": "develop", "oid": "def456..."}
    ]
  }
]
```

### `reports.txt`
Comprehensive analysis report including:
- Organization overview
- Repository details
- File statistics per repository and branch
- File type breakdowns
- Storage usage analysis
- Global summary across all repositories

## 🛠️ Local Execution

### Using the Analysis Script

```bash
# Basic usage
./scripts/analyze.sh -o myorganization

# Custom output file
./scripts/analyze.sh -o myorganization -f custom_report.txt

# Only fetch repositories
./scripts/analyze.sh -o myorganization --fetch-only

# Only analyze (assumes repos.json exists)
./scripts/analyze.sh --analyze-only

# Show help
./scripts/analyze.sh --help
```

### Using Python Script Directly

```bash
cd scripts
python3 analyze_repos.py myorganization
# or with custom output
python3 analyze_repos.py myorganization ../my_custom_report.txt
```

## 📝 Report Contents

### Report Structure

The generated report includes:

1. **Header Section**
   - Organization name
   - Generation timestamp
   - Total repositories count

2. **Per-Repository Sections**
   - Repository name and URL
   - Privacy status (Public/Private)
   - Description
   - Creation date
   - Update date
   - Available branches
   - File statistics by type
   - Total files and storage

3. **Global Summary**
   - Total files across all repositories
   - Total storage used
   - File type distribution
   - Top file types by count and size
   - Percentage breakdowns

### File Type Categories

The analyzer categorizes files into:
- **Programming Languages**: Python, JavaScript, Java, Go, Rust, etc.
- **Markup/Config**: JSON, YAML, XML, TOML, etc.
- **Documentation**: Markdown, ReStructuredText, etc.
- **Styles**: CSS, SCSS, SASS, LESS
- **Media**: Images, Video, Audio
- **Archives**: ZIP, TAR, GZ, etc.
- **Documents**: PDF, Word, Excel, etc.
- **Other**: Miscellaneous files

## ⚙️ Configuration

### Modifying Workflow Schedules

Edit `.github/workflows/fetch-repos.yml`:
```yaml
schedule:
  - cron: '0 2 * * *'  # Change time here
```

Common cron patterns:
- `0 2 * * *` - Daily at 2 AM UTC
- `0 */6 * * *` - Every 6 hours
- `0 0 * * 0` - Weekly on Sunday
- `0 0 1 * *` - Monthly on the 1st

### Customizing Report Details

Edit `.github/workflows/generate-report.yml` to:
- Change which branches are analyzed (currently first 10)
- Modify file type categories
- Add additional statistics
- Change output format

## 🔐 Security Considerations

### Token Permissions

The workflows use `${{ secrets.GITHUB_TOKEN }}` which has limited permissions:
- Read-only access to repositories
- Cannot modify code or settings
- Cannot delete repositories

### Data Privacy

- Private repositories are marked clearly in reports
- All data stays within your GitHub organization
- Reports are artifacts and can be kept private

## 🐛 Troubleshooting

### Issue: "gh" command not found

**Solution**: Install GitHub CLI
```bash
brew install gh  # macOS
sudo apt install gh  # Ubuntu/Debian
```

### Issue: Authentication failed

**Solution**: Ensure GitHub CLI is authenticated
```bash
gh auth login
```

### Issue: Workflow fails with "No repositories found"

**Possible causes**:
- Organization name is incorrect
- Token doesn't have access to organization
- Organization has no public repositories

**Solution**:
1. Verify organization name
2. Ensure token has org:read permission
3. Check organization settings

### Issue: Report file is empty

**Solution**:
1. Check workflow logs for errors
2. Verify repositories.json was created
3. Increase GitHub API timeout values

## 📈 Example Report Snippets

```
==================================================
REPOSITORY #1: my-awesome-repo
==================================================
URL: https://github.com/myorg/my-awesome-repo
Status: PUBLIC
Description: An awesome repository
Created: 2023-01-15T10:30:00Z
Default Branch: main

Total Files: 1,245
Total Size: 125,432,100 bytes (119.62 MB)

FILE TYPE BREAKDOWN (Top 20):
  Extension       Type                  Count      Size (bytes)     Size (MB)
  ──────────────────────────────────────────────────────────────────────────
  js              JavaScript             342       52,340,123       49.87
  json            JSON                   128       12,340,456       11.76
  py              Python                 89        8,123,456        7.74
  css             CSS                    67        5,234,123        4.99
  ...
```

## 🔄 Advanced Usage

### Analyzing Multiple Organizations

Create separate workflow files for each organization or modify the workflows to accept organization as input:

```bash
# Add to workflow file
inputs:
  org_name:
    description: 'Organization name'
    required: true
```

### Custom Report Formats

Modify the Python scripts to generate reports in different formats:
- CSV for spreadsheet analysis
- HTML for web viewing
- PDF for sharing

### Integration with Other Tools

Export reports to:
- Slack notifications
- Email reports
- Cloud storage (S3, Azure Blob)
- Data warehouses for analysis

## 📚 Additional Resources

- [GitHub CLI Documentation](https://cli.github.com)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub API Reference](https://docs.github.com/en/rest)

## 📄 Files Structure

```
github_actions_projects/
├── .github/
│   └── workflows/
│       ├── fetch-repos.yml           # Workflow to fetch repositories
│       └── generate-report.yml       # Workflow to generate report
├── scripts/
│   ├── analyze_repos.py              # Python analyzer script
│   └── analyze.sh                    # Shell script wrapper
├── repos/
│   └── repositories.json             # Generated repositories list
├── reports.txt                       # Generated analysis report
└── README.md                         # This file
```

## 🚀 Next Steps

1. **Run the fetch-repos workflow**: Go to Actions → Fetch Repositories → Run workflow
2. **Monitor the execution**: Check the workflow run logs
3. **View the report**: Download `reports.txt` from artifacts or find it in the repository
4. **Customize as needed**: Edit workflows and scripts for your specific needs
5. **Set up schedule**: The workflows run daily by default (adjustable via cron)

## 💡 Tips & Tricks

- **Large Organizations**: For organizations with 100+ repos, consider adjusting timeouts
- **Archive Reports**: Set up a separate backup system for long-term report history
- **Compare Reports**: Keep archived reports to track changes over time
- **Optimize Performance**: Limit branches analyzed per repo if repos are very large
- **Email Reports**: Use actions/upload-artifact results to email reports automatically

## 🤝 Contributing

To improve this solution:
1. Fork the repository
2. Create a feature branch
3. Make improvements
4. Submit a pull request

### Areas for Contribution

- Additional report formats (CSV, HTML, PDF)
- Performance optimizations for large organizations
- Enhanced analytics and metrics
- Better error handling
- Additional file type categories

## 📞 Support

For issues or questions:
1. Check the Troubleshooting section
2. Review GitHub Actions logs
3. Check GitHub CLI status with `gh status`
4. Review repository settings

## 📜 License

This project is provided as-is for analysis and reporting purposes.

---

**Last Updated**: 2024-01-20
**Version**: 1.0.0

For the latest updates, check the repository main branch.
