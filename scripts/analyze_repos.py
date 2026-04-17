#!/usr/bin/env python3
"""
Advanced Repository Analyzer
Analyzes files in repositories and generates detailed reports
"""

import json
import subprocess
import os
import sys
from datetime import datetime
from pathlib import Path
from collections import defaultdict
import re

class RepositoryAnalyzer:
    """Analyzes GitHub repositories and generates comprehensive reports"""
    
    # File type categories
    PROGRAMMING_LANGUAGES = {
        'py': 'Python', 'js': 'JavaScript', 'ts': 'TypeScript', 'java': 'Java',
        'cpp': 'C++', 'c': 'C', 'cs': 'C#', 'go': 'Go', 'rs': 'Rust',
        'rb': 'Ruby', 'php': 'PHP', 'swift': 'Swift', 'kt': 'Kotlin',
        'scala': 'Scala', 'r': 'R', 'lua': 'Lua', 'pl': 'Perl',
        'sh': 'Shell', 'bash': 'Bash', 'zsh': 'Zsh'
    }
    
    MARKUP_LANGUAGES = {
        'html': 'HTML', 'xml': 'XML', 'json': 'JSON', 'yaml': 'YAML',
        'yml': 'YAML', 'toml': 'TOML', 'ini': 'INI', 'cfg': 'Config',
        'conf': 'Config', 'properties': 'Properties'
    }
    
    MARKUP_DOCUMENTS = {
        'md': 'Markdown', 'rst': 'ReStructuredText', 'adoc': 'AsciiDoc',
        'txt': 'Text', 'tex': 'LaTeX'
    }
    
    STYLE_SHEETS = {
        'css': 'CSS', 'scss': 'SCSS', 'sass': 'SASS', 'less': 'LESS'
    }
    
    def __init__(self, org_name, token=None):
        self.org_name = org_name
        self.token = token or os.getenv('GH_TOKEN', '')
        self.repos_data = []
        
    def fetch_repositories(self):
        """Fetch all repositories from organization"""
        print(f"Fetching repositories from {self.org_name}...")
        cmd = f'gh repo list {self.org_name} --limit 1000 --json name,owner,url,description,createdAt,updatedAt,isPrivate,languages --no-truncate'
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        
        if result.returncode != 0:
            print(f"Error: {result.stderr}")
            return False
        
        self.repos_data = json.loads(result.stdout)
        print(f"✓ Found {len(self.repos_data)} repositories")
        return True
    
    def get_file_type_category(self, file_ext):
        """Categorize file by extension"""
        ext = file_ext.lower()
        
        if ext in self.PROGRAMMING_LANGUAGES:
            return 'Programming', self.PROGRAMMING_LANGUAGES[ext]
        elif ext in self.MARKUP_LANGUAGES:
            return 'Markup', self.MARKUP_LANGUAGES[ext]
        elif ext in self.MARKUP_DOCUMENTS:
            return 'Documentation', self.MARKUP_DOCUMENTS[ext]
        elif ext in self.STYLE_SHEETS:
            return 'Style', self.STYLE_SHEETS[ext]
        elif ext in ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg', 'ico']:
            return 'Image', f'{ext.upper()} Image'
        elif ext in ['mp4', 'avi', 'mov', 'flv', 'wmv']:
            return 'Video', f'{ext.upper()} Video'
        elif ext in ['mp3', 'wav', 'flac', 'aac', 'm4a']:
            return 'Audio', f'{ext.upper()} Audio'
        elif ext in ['zip', 'tar', 'gz', 'rar', '7z', 'bz2']:
            return 'Archive', f'{ext.upper()} Archive'
        elif ext in ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx']:
            return 'Document', f'{ext.upper()} Document'
        else:
            return 'Other', f'.{ext}'
    
    def count_words_in_file(self, owner, repo, branch, file_path):
        """Count words in a file"""
        try:
            cmd = f'gh api repos/{owner}/{repo}/contents/{file_path}?ref={branch} --jq ".content"'
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=10)
            
            if result.returncode == 0:
                # Count words (simple split on whitespace)
                import base64
                try:
                    content = base64.b64decode(result.stdout.strip()).decode('utf-8', errors='ignore')
                    word_count = len(content.split())
                    return word_count
                except:
                    return 0
        except:
            pass
        return 0
    
    def generate_detailed_report(self, output_file='reports.txt'):
        """Generate comprehensive report"""
        print("Generating detailed report...")
        
        report_lines = []
        report_lines.append("=" * 140)
        report_lines.append("COMPREHENSIVE GITHUB ORGANIZATION ANALYSIS REPORT")
        report_lines.append(f"Organization: {self.org_name}")
        report_lines.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')}")
        report_lines.append("=" * 140)
        report_lines.append("")
        
        # Statistics
        total_repos = len(self.repos_data)
        private_repos = sum(1 for r in self.repos_data if r.get('isPrivate', False))
        public_repos = total_repos - private_repos
        
        report_lines.append(f"ORGANIZATION OVERVIEW")
        report_lines.append(f"{'─' * 140}")
        report_lines.append(f"Total Repositories: {total_repos}")
        report_lines.append(f"Public Repositories: {public_repos}")
        report_lines.append(f"Private Repositories: {private_repos}")
        report_lines.append("")
        
        # Global statistics
        global_file_stats = defaultdict(lambda: {"count": 0, "size": 0, "category": ""})
        global_lang_stats = defaultdict(int)
        total_files = 0
        total_size = 0
        
        # Analyze each repository
        for idx, repo in enumerate(self.repos_data, 1):
            repo_name = repo.get('name', '')
            owner = repo.get('owner', {}).get('login', self.org_name)
            description = repo.get('description', 'N/A') or 'N/A'
            created_at = repo.get('createdAt', 'N/A')
            updated_at = repo.get('updatedAt', 'N/A')
            is_private = repo.get('isPrivate', False)
            languages = repo.get('languages', {})
            
            report_lines.append(f"\n{'─' * 140}")
            report_lines.append(f"#{idx}. REPOSITORY: {repo_name}")
            report_lines.append(f"{'─' * 140}")
            report_lines.append(f"Owner: {owner}")
            report_lines.append(f"Status: {'PRIVATE' if is_private else 'PUBLIC'}")
            report_lines.append(f"Description: {description}")
            report_lines.append(f"Created: {created_at}")
            report_lines.append(f"Updated: {updated_at}")
            
            if languages:
                langs_str = ", ".join([f"{lang} ({bytes_})" for lang, bytes_ in sorted(languages.items(), key=lambda x: x[1], reverse=True)[:5]])
                report_lines.append(f"Languages: {langs_str}")
            
            report_lines.append("")
            
            # Fetch default branch
            try:
                ref_cmd = f'gh api repos/{owner}/{repo_name} --jq ".default_branch"'
                ref_result = subprocess.run(ref_cmd, shell=True, capture_output=True, text=True, timeout=10)
                default_branch = ref_result.stdout.strip() if ref_result.returncode == 0 else 'main'
            except:
                default_branch = 'main'
            
            report_lines.append(f"DEFAULT BRANCH: {default_branch}")
            
            # Fetch files from default branch
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
                        repo_file_stats = defaultdict(lambda: {"count": 0, "size": 0, "category": ""})
                        repo_total_files = 0
                        repo_total_size = 0
                        
                        for file_obj in files_data:
                            if file_obj.get('type') == 'blob':
                                file_path = file_obj.get('path', '')
                                file_size = file_obj.get('size', 0)
                                
                                # Get extension
                                if '.' in file_path and not file_path.startswith('.'):
                                    file_ext = file_path.rsplit('.', 1)[1].lower()
                                else:
                                    file_ext = 'no-ext'
                                
                                category, file_type = self.get_file_type_category(file_ext)
                                
                                repo_file_stats[file_ext]["count"] += 1
                                repo_file_stats[file_ext]["size"] += file_size
                                repo_file_stats[file_ext]["category"] = file_type
                                
                                global_file_stats[file_ext]["count"] += 1
                                global_file_stats[file_ext]["size"] += file_size
                                global_file_stats[file_ext]["category"] = file_type
                                
                                repo_total_files += 1
                                repo_total_size += file_size
                                total_files += 1
                                total_size += file_size
                        
                        if repo_total_files > 0:
                            report_lines.append(f"Total Files: {repo_total_files}")
                            report_lines.append(f"Total Size: {repo_total_size:,} bytes ({repo_total_size / (1024*1024):.2f} MB)")
                            report_lines.append("")
                            report_lines.append(f"FILE TYPE BREAKDOWN (Top 20):")
                            report_lines.append(f"  {'Extension':<15} {'Type':<20} {'Count':>10} {'Size (bytes)':>15} {'Size (MB)':>12}")
                            report_lines.append(f"  {'-'*70}")
                            
                            sorted_types = sorted(repo_file_stats.items(), key=lambda x: x[1]["count"], reverse=True)[:20]
                            for ext, stats in sorted_types:
                                count = stats["count"]
                                size = stats["size"]
                                file_type = stats["category"]
                                size_mb = size / (1024*1024)
                                report_lines.append(f"  {ext:<15} {file_type:<20} {count:>10,} {size:>15,} {size_mb:>12.2f}")
                        else:
                            report_lines.append(f"No files found or unable to fetch data for default branch")
            except subprocess.TimeoutExpired:
                report_lines.append("ERROR: Timeout fetching file data")
            except Exception as e:
                report_lines.append(f"ERROR: {str(e)}")
            
            report_lines.append("")
        
        # Global summary
        report_lines.append("\n" + "=" * 140)
        report_lines.append("GLOBAL SUMMARY ACROSS ALL REPOSITORIES")
        report_lines.append("=" * 140)
        report_lines.append(f"Total Repositories Analyzed: {total_repos}")
        report_lines.append(f"Total Files Across All Repos: {total_files:,}")
        report_lines.append(f"Total Storage Used: {total_size:,} bytes ({total_size / (1024*1024*1024):.2f} GB)")
        report_lines.append("")
        
        if global_file_stats:
            report_lines.append(f"FILE TYPE DISTRIBUTION (Top 50):")
            report_lines.append(f"  {'Extension':<15} {'Type':<20} {'Count':>10} {'Size (bytes)':>15} {'Size (MB)':>12} {'% of Total':>12}")
            report_lines.append(f"  {'-'*85}")
            
            sorted_global = sorted(global_file_stats.items(), key=lambda x: x[1]["count"], reverse=True)[:50]
            for ext, stats in sorted_global:
                count = stats["count"]
                size = stats["size"]
                file_type = stats["category"]
                size_mb = size / (1024*1024)
                percentage = (count / total_files * 100) if total_files > 0 else 0
                report_lines.append(f"  {ext:<15} {file_type:<20} {count:>10,} {size:>15,} {size_mb:>12.2f} {percentage:>11.1f}%")
        
        report_lines.append("")
        report_lines.append("=" * 140)
        report_lines.append("END OF REPORT")
        report_lines.append("=" * 140)
        
        # Write report
        with open(output_file, 'w') as f:
            f.write('\n'.join(report_lines))
        
        print(f"✓ Report generated: {output_file}")
        print(f"  - Total files: {total_files:,}")
        print(f"  - Total size: {total_size / (1024*1024*1024):.2f} GB")
        
        return True

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 analyze_repos.py <org_name> [output_file]")
        print("Example: python3 analyze_repos.py myorg reports.txt")
        sys.exit(1)
    
    org_name = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else 'reports.txt'
    
    analyzer = RepositoryAnalyzer(org_name)
    
    if analyzer.fetch_repositories():
        analyzer.generate_detailed_report(output_file)
    else:
        print("Failed to fetch repositories")
        sys.exit(1)

if __name__ == '__main__':
    main()
