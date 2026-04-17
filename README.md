# GitHub Organization Repository Analyzer

Complete end-to-end solution to analyze all repositories in a GitHub organization, collect file metadata, and generate comprehensive reports.

## 📋 Task Overview

### ✅ Task 1: Fetch Repositories
- Fetch all repositories from GitHub organization
- Retrieve repository metadata (name, URL, branches, creation date, etc.)
- Store results in `repos/repositories.json`

### ✅ Task 2: Process Repository Data
- Read `repositories.json` as input
- Iterate through each repository and all its branches
- Collect file metadata for each file:
  - File type
  - File size
  - File creation context
  - Word count (for text files)
  - File extension categorization

### ✅ Task 3: Generate Reports
- Analyze collected file statistics
- Generate comprehensive `reports.txt` with:
  - Per-repository file statistics
  - File type breakdowns
  - Storage usage analysis
  - Global organization-wide summary
  - Aggregated metrics and insights

## 🎯 Solution Components

### GitHub Actions Workflows

#### 1. Fetch Repositories Workflow (`.github/workflows/fetch-repos.yml`)
- **Trigger**: Manual or Daily at 2 AM UTC
- **Purpose**: Fetch all org repositories and save to JSON
- **Output**: `repos/repositories.json` artifact
- **Runtime**: ~2-3 minutes

#### 2. Generate Report Workflow (`.github/workflows/generate-report.yml`)
- **Trigger**: Automatically after fetch-repos completes or manual
- **Purpose**: Analyze repos and generate detailed report
- **Output**: `reports.txt` artifact
- **Runtime**: ~3-5 minutes

### Python Scripts

#### `scripts/analyze_repos.py`
Advanced repository analyzer with:
- File type categorization
- Detailed statistics collection
- Per-repository and global analysis
- Comprehensive report generation

#### `scripts/analyze.sh`
Shell script wrapper for local execution supporting:
- Fetch-only mode
- Analyze-only mode
- Custom output paths
- Help documentation

### Documentation

- **WORKFLOW_README.md**: Complete workflow documentation
- **WORKFLOW_CONFIG.md**: Configuration and customization guide
- **QUICK_START.md**: 5-minute quick start guide
- **This README.md**: Project overview

## 📦 Quick Start

1. **Verify Setup**:
   ```bash
   chmod +x scripts/verify-setup.sh
   ./scripts/verify-setup.sh
   ```

2. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Add GitHub organization analyzer"
   git push origin main
   ```

3. **Trigger Workflow**:
   - Go to Actions tab
   - Select "Fetch Repositories"
   - Click "Run workflow"

4. **View Results**:
   - Check artifacts after workflow completes
   - Download `repositories.json` and `reports.txt`

For detailed instructions, see [QUICK_START.md](QUICK_START.md)

## 📊 Report Structure

The generated `reports.txt` includes:

```
ORGANIZATION OVERVIEW
├── Total repositories
├── Public vs Private count
└── Timeline

PER-REPOSITORY ANALYSIS
├── Repository metadata
├── Default branch files
├── File type breakdown
├── Storage usage
└── Statistical summary

GLOBAL SUMMARY
├── Total files across org
├── Total storage used
├── File type distribution
└── Technology stack analysis
```

## 💻 Local Usage

### Using Shell Script
```bash
# Basic run
./scripts/analyze.sh -o your-org

# Custom output
./scripts/analyze.sh -o your-org -f my_report.txt

# Fetch only
./scripts/analyze.sh -o your-org --fetch-only
```

### Using Python Directly
```bash
python3 scripts/analyze_repos.py your-org-name
```

## 🛠️ Configuration

- **Schedule**: Edit cron in `.github/workflows/fetch-repos.yml`
- **Branch Limit**: Modify in `generate-report.yml`
- **File Categories**: Customize in Python scripts
- **Report Format**: Adjust output in analysis scripts

See [WORKFLOW_CONFIG.md](WORKFLOW_CONFIG.md) for detailed options.

## 📁 File Structure

```
.
├── .github/workflows/
│   ├── fetch-repos.yml              # Fetch repositories workflow
│   └── generate-report.yml          # Generate report workflow
├── scripts/
│   ├── analyze_repos.py             # Python analyzer
│   ├── analyze.sh                   # Shell wrapper
│   └── verify-setup.sh              # Setup verification
├── repos/
│   ├── repositories.json            # Generated repo list
│   └── repositories.example.json    # Example format
├── reports.txt                      # Generated report
├── reports.example.txt              # Example report
├── WORKFLOW_README.md               # Full documentation
├── WORKFLOW_CONFIG.md               # Configuration guide
├── QUICK_START.md                   # Quick start guide
└── .gitignore                       # Git ignore rules
```

## 🔐 Security

- Uses GitHub Token (automatic)
- Read-only access to repositories
- Private repos clearly marked in reports
- No data modification or deletion

## 🚀 Features

- ✅ Automated daily repository fetching
- ✅ Comprehensive file analysis
- ✅ Multiple file type categorization
- ✅ Storage usage tracking
- ✅ JSON and text report formats
- ✅ Local and cloud execution
- ✅ Detailed documentation
- ✅ Error handling and logging
- ✅ Configurable scheduling
- ✅ Artifact management

## 📊 Use Cases

1. **Organization Audit**: Understand repository structure and technology stack
2. **Storage Planning**: Track disk usage across repositories
3. **Compliance**: Monitor file types and code organization
4. **Growth Tracking**: Compare reports over time
5. **Architecture Analysis**: Identify projects by technology
6. **Team Planning**: Estimate project complexity

## 🐛 Troubleshooting

Common issues and solutions:

| Issue | Solution |
|-------|----------|
| `gh: command not found` | Install GitHub CLI from https://cli.github.com |
| `Authentication failed` | Run `gh auth login` |
| `No repositories found` | Check org name and token permissions |
| `Workflow not triggering` | Enable GitHub Actions in settings |

See [QUICK_START.md](QUICK_START.md) for more troubleshooting.

## 📚 Documentation

- **[QUICK_START.md](QUICK_START.md)** - Get started in 5 minutes
- **[WORKFLOW_README.md](WORKFLOW_README.md)** - Complete workflow documentation
- **[WORKFLOW_CONFIG.md](WORKFLOW_CONFIG.md)** - Configuration and customization
- **[reports.example.txt](reports.example.txt)** - Example report format
- **[repos/repositories.example.json](repos/repositories.example.json)** - Example JSON format

## 🔄 Workflow Execution Flow

```
┌─────────────────────────────────┐
│  Fetch Repositories Workflow    │
│  (fetch-repos.yml)              │
│  - Triggered: Manual/Daily      │
│  - Fetches: All repos + branches│
│  - Output: repositories.json    │
└────────────────┬────────────────┘
                 │
                 ▼
         ┌──────────────┐
         │ Upload as    │
         │ Artifact     │
         └──────────────┘
                 │
                 ▼
┌─────────────────────────────────┐
│ Generate Report Workflow        │
│ (generate-report.yml)           │
│ - Triggered: After fetch-repos  │
│ - Input: repositories.json      │
│ - Analyzes: Files & metadata    │
│ - Output: reports.txt           │
└────────────────┬────────────────┘
                 │
                 ▼
         ┌──────────────┐
         │ Upload as    │
         │ Artifact     │
         └──────────────┘
                 │
                 ▼
        ┌────────────────┐
        │ reports.txt    │
        │ (Ready for use)│
        └────────────────┘
```

## ✨ Next Steps

1. Review all documentation files
2. Run setup verification: `./scripts/verify-setup.sh`
3. Push to GitHub
4. Trigger first workflow run
5. Review generated reports
6. Customize configuration as needed

## 📝 License

This project is provided as-is for GitHub organization analysis and reporting.

---

**Version**: 1.0.0  
**Last Updated**: January 20, 2024
