#!/bin/bash
# Manual Repository Analysis Script
# Use this to generate reports locally without GitHub Actions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
ORG_NAME=""
OUTPUT_FILE="reports.txt"
REPOS_JSON="repos/repositories.json"

# Functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

show_help() {
    cat << EOF
Repository Analysis Tool

Usage: $0 [OPTIONS]

Options:
    -o, --org ORG_NAME          GitHub organization name (required)
    -f, --file OUTPUT_FILE      Output file path (default: reports.txt)
    -j, --json REPOS_FILE       Repositories JSON file (default: repos/repositories.json)
    --fetch-only               Only fetch repos, don't generate report
    --analyze-only             Only analyze, assume repos.json exists
    --help                      Show this help message

Examples:
    # Generate report for organization
    $0 -o myorg

    # Generate report with custom output file
    $0 -o myorg -f my_report.txt

    # Only fetch repositories
    $0 -o myorg --fetch-only

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--org)
            ORG_NAME="$2"
            shift 2
            ;;
        -f|--file)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -j|--json)
            REPOS_JSON="$2"
            shift 2
            ;;
        --fetch-only)
            FETCH_ONLY=1
            shift
            ;;
        --analyze-only)
            ANALYZE_ONLY=1
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate inputs
if [ -z "$ORG_NAME" ] && [ -z "$ANALYZE_ONLY" ]; then
    print_error "Organization name is required"
    show_help
    exit 1
fi

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) is not installed"
    echo "Please install it from: https://cli.github.com"
    exit 1
fi

print_header "Repository Analysis Tool"

# Step 1: Fetch repositories
if [ -z "$ANALYZE_ONLY" ]; then
    print_header "Step 1: Fetching Repositories from $ORG_NAME"
    
    mkdir -p repos
    
    python3 << 'PYTHON_EOF'
import subprocess
import json
import os

org_name = os.getenv('ORG_NAME', '')
print(f"Fetching repositories from {org_name}...")

cmd = f'gh repo list {org_name} --limit 1000 --json name,owner,url,description,createdAt,isPrivate --no-truncate'
result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

if result.returncode != 0:
    print(f"Error: {result.stderr}")
    exit(1)

repos_data = json.loads(result.stdout)
print(f"✓ Found {len(repos_data)} repositories")

# Save to JSON
output_file = os.getenv('REPOS_JSON', 'repos/repositories.json')
with open(output_file, 'w') as f:
    json.dump(repos_data, f, indent=2)

print(f"✓ Saved to {output_file}")
PYTHON_EOF
    
    if [ $? -ne 0 ]; then
        print_error "Failed to fetch repositories"
        exit 1
    fi
    
    print_success "Repositories fetched"
fi

# Step 2: Analyze repositories and generate report
if [ -z "$FETCH_ONLY" ]; then
    print_header "Step 2: Generating Analysis Report"
    
    if [ ! -f "$REPOS_JSON" ] && [ -z "$ANALYZE_ONLY" ]; then
        print_error "Repository JSON file not found: $REPOS_JSON"
        exit 1
    fi
    
    python3 << 'PYTHON_EOF'
import json
import subprocess
import os
from datetime import datetime
from collections import defaultdict

org_name = os.getenv('ORG_NAME', 'Organization')
repos_json = os.getenv('REPOS_JSON', 'repos/repositories.json')
output_file = os.getenv('OUTPUT_FILE', 'reports.txt')

report_lines = []

# Header
report_lines.append("=" * 140)
report_lines.append("GITHUB ORGANIZATION REPOSITORY ANALYSIS REPORT")
report_lines.append(f"Organization: {org_name}")
report_lines.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')}")
report_lines.append("=" * 140)
report_lines.append("")

# Load data
if os.path.exists(repos_json):
    with open(repos_json, 'r') as f:
        repos_data = json.load(f)
else:
    repos_data = []

if not repos_data:
    report_lines.append("ERROR: No repositories found!")
    with open(output_file, 'w') as f:
        f.write('\n'.join(report_lines))
    exit(1)

report_lines.append(f"Total Repositories: {len(repos_data)}")
report_lines.append("")

# Statistics
total_files = 0
total_size = 0
file_stats = defaultdict(lambda: {"count": 0, "size": 0})

# Analyze each repository
for idx, repo in enumerate(repos_data, 1):
    repo_name = repo.get('name', 'Unknown')
    owner = repo.get('owner', {}).get('login', org_name)
    url = repo.get('url', '')
    description = repo.get('description', 'N/A')
    created_at = repo.get('createdAt', 'N/A')
    is_private = repo.get('isPrivate', False)
    
    report_lines.append(f"\n{'─' * 140}")
    report_lines.append(f"REPO #{idx}: {repo_name}")
    report_lines.append(f"{'─' * 140}")
    report_lines.append(f"URL: {url}")
    report_lines.append(f"Status: {'PRIVATE' if is_private else 'PUBLIC'}")
    report_lines.append(f"Description: {description}")
    report_lines.append(f"Created: {created_at}")
    report_lines.append("")
    
    # Get default branch
    try:
        ref_cmd = f'gh api repos/{owner}/{repo_name} --jq ".default_branch"'
        ref_result = subprocess.run(ref_cmd, shell=True, capture_output=True, text=True, timeout=10)
        default_branch = ref_result.stdout.strip() if ref_result.returncode == 0 else 'main'
    except:
        default_branch = 'main'
    
    report_lines.append(f"Default Branch: {default_branch}")
    
    # Fetch files
    try:
        files_cmd = f'gh api repos/{owner}/{repo_name}/git/trees/{default_branch}?recursive=1 --jq ".tree[]"'
        files_result = subprocess.run(files_cmd, shell=True, capture_output=True, text=True, timeout=30)
        
        if files_result.returncode == 0:
            files_data = []
            try:
                files_data = json.loads(files_result.stdout)
            except:
                pass
            
            if isinstance(files_data, list):
                repo_file_stats = defaultdict(lambda: {"count": 0, "size": 0})
                repo_total_files = 0
                repo_total_size = 0
                
                for file_obj in files_data:
                    if file_obj.get('type') == 'blob':
                        file_path = file_obj.get('path', '')
                        file_size = file_obj.get('size', 0)
                        
                        if '.' in file_path:
                            file_ext = file_path.rsplit('.', 1)[1].lower()
                        else:
                            file_ext = 'no-ext'
                        
                        repo_file_stats[file_ext]["count"] += 1
                        repo_file_stats[file_ext]["size"] += file_size
                        
                        file_stats[file_ext]["count"] += 1
                        file_stats[file_ext]["size"] += file_size
                        
                        repo_total_files += 1
                        repo_total_size += file_size
                        total_files += 1
                        total_size += file_size
                
                if repo_total_files > 0:
                    report_lines.append(f"Total Files: {repo_total_files:,}")
                    report_lines.append(f"Total Size: {repo_total_size:,} bytes ({repo_total_size / (1024*1024):.2f} MB)")
                    report_lines.append("")
                    report_lines.append(f"File Type Breakdown (Top 10):")
                    
                    sorted_types = sorted(repo_file_stats.items(), key=lambda x: x[1]["count"], reverse=True)[:10]
                    for ext, stats in sorted_types:
                        count = stats["count"]
                        size = stats["size"]
                        size_mb = size / (1024*1024)
                        report_lines.append(f"  .{ext:<15} : {count:>7} files | {size:>15,} bytes ({size_mb:>10.2f} MB)")
                else:
                    report_lines.append(f"No files found")
    except Exception as e:
        report_lines.append(f"Error fetching files: {str(e)}")
    
    report_lines.append("")

# Summary
report_lines.append("\n" + "=" * 140)
report_lines.append("SUMMARY")
report_lines.append("=" * 140)
report_lines.append(f"Total Files: {total_files:,}")
report_lines.append(f"Total Size: {total_size:,} bytes ({total_size / (1024*1024*1024):.2f} GB)")
report_lines.append("")

if file_stats:
    report_lines.append("Overall File Type Distribution:")
    sorted_types = sorted(file_stats.items(), key=lambda x: x[1]["count"], reverse=True)[:30]
    for ext, stats in sorted_types:
        count = stats["count"]
        size = stats["size"]
        size_mb = size / (1024*1024)
        report_lines.append(f"  .{ext:<15} : {count:>7} files | {size:>15,} bytes ({size_mb:>10.2f} MB)")

report_lines.append("")
report_lines.append("=" * 140)
report_lines.append("END OF REPORT")
report_lines.append("=" * 140)

# Write report
with open(output_file, 'w') as f:
    f.write('\n'.join(report_lines))

print(f"✓ Report generated: {output_file}")
print(f"  Total files: {total_files:,}")
print(f"  Total size: {total_size / (1024*1024*1024):.2f} GB")
PYTHON_EOF
    
    if [ $? -ne 0 ]; then
        print_error "Failed to generate report"
        exit 1
    fi
    
    print_success "Report generated: $OUTPUT_FILE"
fi

print_header "Analysis Complete"
print_success "All done!"

# Display report summary
if [ -f "$OUTPUT_FILE" ]; then
    echo ""
    echo "Report preview (first 50 lines):"
    echo "─────────────────────────────────"
    head -50 "$OUTPUT_FILE"
    echo ""
    echo "... [full report in $OUTPUT_FILE] ..."
fi
