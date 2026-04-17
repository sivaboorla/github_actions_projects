#!/bin/bash
# Setup verification script
# Check if all necessary files are in place and properly configured

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "════════════════════════════════════════════════════════════════"
echo "GitHub Organization Repository Analyzer - Setup Verification"
echo "════════════════════════════════════════════════════════════════"
echo -e "${NC}"

ISSUES=0
WARNINGS=0

# Check Python
echo ""
echo "Checking Python installation..."
if command -v python3 &> /dev/null; then
    VERSION=$(python3 --version)
    echo -e "${GREEN}✓${NC} Python installed: $VERSION"
else
    echo -e "${RED}✗${NC} Python 3 not found"
    ((ISSUES++))
fi

# Check GitHub CLI
echo ""
echo "Checking GitHub CLI installation..."
if command -v gh &> /dev/null; then
    VERSION=$(gh --version | head -1)
    echo -e "${GREEN}✓${NC} GitHub CLI installed: $VERSION"
else
    echo -e "${RED}✗${NC} GitHub CLI not found"
    echo "  Install from: https://cli.github.com"
    ((ISSUES++))
fi

# Check GitHub authentication
echo ""
echo "Checking GitHub authentication..."
if gh auth status &> /dev/null; then
    USER=$(gh api user --jq '.login')
    echo -e "${GREEN}✓${NC} Authenticated as: $USER"
else
    echo -e "${YELLOW}⚠${NC} Not authenticated with GitHub"
    echo "  Run: gh auth login"
    ((WARNINGS++))
fi

# Check required directories
echo ""
echo "Checking required directories..."
DIRS=(".github/workflows" "scripts" "repos")
for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} Directory exists: $dir"
    else
        echo -e "${RED}✗${NC} Directory missing: $dir"
        ((ISSUES++))
    fi
done

# Check required files
echo ""
echo "Checking required files..."
FILES=(
    ".github/workflows/fetch-repos.yml"
    ".github/workflows/generate-report.yml"
    "scripts/analyze_repos.py"
    "scripts/analyze.sh"
    "WORKFLOW_README.md"
    "WORKFLOW_CONFIG.md"
    "QUICK_START.md"
)
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} File exists: $file"
    else
        echo -e "${RED}✗${NC} File missing: $file"
        ((ISSUES++))
    fi
done

# Check script permissions
echo ""
echo "Checking script permissions..."
if [ -f "scripts/analyze.sh" ]; then
    if [ -x "scripts/analyze.sh" ]; then
        echo -e "${GREEN}✓${NC} scripts/analyze.sh is executable"
    else
        echo -e "${YELLOW}⚠${NC} scripts/analyze.sh is not executable"
        echo "  Run: chmod +x scripts/analyze.sh"
        ((WARNINGS++))
    fi
fi

# Check Git repository
echo ""
echo "Checking Git repository..."
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Git repository initialized"
    
    # Check if changes are committed
    if [ -z "$(git status --porcelain)" ]; then
        echo -e "${GREEN}✓${NC} Working directory clean"
    else
        echo -e "${YELLOW}⚠${NC} Uncommitted changes found"
        echo "  Run: git add . && git commit -m 'Add workflows'"
        ((WARNINGS++))
    fi
else
    echo -e "${YELLOW}⚠${NC} Not a Git repository"
    ((WARNINGS++))
fi

# Check .gitignore
echo ""
echo "Checking .gitignore..."
if [ -f ".gitignore" ]; then
    if grep -q "reports.txt" .gitignore; then
        echo -e "${GREEN}✓${NC} .gitignore properly configured"
    else
        echo -e "${YELLOW}⚠${NC} .gitignore may need updates"
        ((WARNINGS++))
    fi
else
    echo -e "${YELLOW}⚠${NC} .gitignore not found"
    ((WARNINGS++))
fi

# Check workflow YAML syntax
echo ""
echo "Checking workflow files..."
for workflow in .github/workflows/*.yml; do
    if [ -f "$workflow" ]; then
        # Simple YAML validation (check for required fields)
        if grep -q "^name:" "$workflow" && \
           grep -q "^on:" "$workflow" && \
           grep -q "^jobs:" "$workflow"; then
            echo -e "${GREEN}✓${NC} Valid structure: $(basename $workflow)"
        else
            echo -e "${RED}✗${NC} Invalid structure: $(basename $workflow)"
            ((ISSUES++))
        fi
    fi
done

# Summary
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"
echo "VERIFICATION SUMMARY"
echo -e "${BLUE}════════════════════════════════════════════════════════════════${NC}"

if [ $ISSUES -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! Your setup is ready.${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Push changes to GitHub: git push origin main"
    echo "  2. Go to Actions tab on GitHub"
    echo "  3. Run 'Fetch Repositories' workflow"
    echo "  4. Monitor execution in Actions logs"
    echo ""
    exit 0
fi

if [ $ISSUES -gt 0 ]; then
    echo -e "${RED}✗ Found $ISSUES critical issue(s)${NC}"
fi

if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠ Found $WARNINGS warning(s)${NC}"
fi

echo ""
if [ $ISSUES -gt 0 ]; then
    echo "Please fix the critical issues before proceeding."
    exit 1
else
    echo "Setup ready (warnings can usually be ignored)."
    exit 0
fi
