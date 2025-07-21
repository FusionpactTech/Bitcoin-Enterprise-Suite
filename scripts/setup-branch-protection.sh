#!/bin/bash

# Branch Protection Setup Script for Bitcoin Enterprise Suite
# This script helps configure branch protection rules using GitHub CLI

set -e

REPO="bitcoin-enterprise-suite/bitcoin-enterprise-suite"
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BOLD}🛡️  Bitcoin Enterprise Suite - Branch Protection Setup${NC}"
echo "=================================================================="

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI (gh) is not installed.${NC}"
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}❌ Not authenticated with GitHub CLI.${NC}"
    echo "Please run: gh auth login"
    exit 1
fi

echo -e "${GREEN}✅ GitHub CLI is installed and authenticated${NC}"

# Function to create branch protection rule
create_branch_protection() {
    local branch_pattern="$1"
    local required_reviews="$2"
    local require_code_owner="$3"
    local enforce_admins="$4"
    local required_checks="$5"
    local allow_force_push="$6"
    local allow_deletions="$7"
    local required_linear_history="$8"
    
    echo -e "${YELLOW}🔧 Setting up protection for branch pattern: $branch_pattern${NC}"
    
    # Build the command
    local cmd="gh api repos/$REPO/branches/$branch_pattern/protection \
        --method PUT \
        --field required_status_checks[strict]=true \
        --field enforce_admins=$enforce_admins \
        --field required_pull_request_reviews[required_approving_review_count]=$required_reviews \
        --field required_pull_request_reviews[dismiss_stale_reviews]=true \
        --field required_pull_request_reviews[require_code_owner_reviews]=$require_code_owner \
        --field required_pull_request_reviews[require_last_push_approval]=true \
        --field required_pull_request_reviews[required_review_thread_resolution]=true \
        --field restrictions=null \
        --field allow_force_pushes[enabled]=$allow_force_push \
        --field allow_deletions[enabled]=$allow_deletions"
    
    if [ "$required_linear_history" = "true" ]; then
        cmd="$cmd --field required_linear_history[enabled]=true"
    fi
    
    # Add required status checks
    if [ -n "$required_checks" ]; then
        IFS=',' read -ra CHECKS <<< "$required_checks"
        for check in "${CHECKS[@]}"; do
            cmd="$cmd --field required_status_checks[contexts][]='$check'"
        done
    fi
    
    # Execute the command
    if eval "$cmd" &> /dev/null; then
        echo -e "${GREEN}✅ Branch protection applied for: $branch_pattern${NC}"
    else
        echo -e "${RED}❌ Failed to apply protection for: $branch_pattern${NC}"
        return 1
    fi
}

# Main branch protection (highest security)
echo -e "\n${BOLD}🔒 Configuring main branch protection...${NC}"
MAIN_CHECKS="CI/CD Pipeline / code-quality,CI/CD Pipeline / test (ubuntu-latest, stable),CI/CD Pipeline / test (windows-latest, stable),CI/CD Pipeline / test (macos-latest, stable),Security Checks / dependency-audit,Security Checks / cargo-deny,Security Checks / secret-scanning,Security Checks / vulnerability-scanning,Security Checks / sast-analysis"

create_branch_protection "main" 2 true true "$MAIN_CHECKS" false false true

# Develop branch protection
echo -e "\n${BOLD}🔧 Configuring develop branch protection...${NC}"
DEVELOP_CHECKS="CI/CD Pipeline / code-quality,CI/CD Pipeline / test (ubuntu-latest, stable),Security Checks / dependency-audit,Security Checks / cargo-deny,Security Checks / secret-scanning"

create_branch_protection "develop" 1 false false "$DEVELOP_CHECKS" false false false

# Function to enable repository security features
enable_security_features() {
    echo -e "\n${BOLD}🛡️  Enabling repository security features...${NC}"
    
    # Enable vulnerability alerts
    if gh api repos/$REPO/vulnerability-alerts --method PUT &> /dev/null; then
        echo -e "${GREEN}✅ Vulnerability alerts enabled${NC}"
    else
        echo -e "${YELLOW}⚠️  Could not enable vulnerability alerts (may already be enabled)${NC}"
    fi
    
    # Enable automated security fixes
    if gh api repos/$REPO/automated-security-fixes --method PUT &> /dev/null; then
        echo -e "${GREEN}✅ Automated security fixes enabled${NC}"
    else
        echo -e "${YELLOW}⚠️  Could not enable automated security fixes (may already be enabled)${NC}"
    fi
    
    echo -e "${GREEN}✅ Security features configuration completed${NC}"
}

# Function to create teams (requires organization admin permissions)
create_teams() {
    echo -e "\n${BOLD}👥 Creating repository teams...${NC}"
    echo -e "${YELLOW}⚠️  Note: Team creation requires organization admin permissions${NC}"
    
    local teams=("maintainers" "security-team" "biscol-team" "cci-sat-team" "aicrm-team" "imo-eo-team" "docs-team" "devops-team" "contributors")
    
    for team in "${teams[@]}"; do
        if gh api orgs/bitcoin-enterprise-suite/teams --method POST \
            --field name="$team" \
            --field description="Team for $team responsibilities" \
            --field privacy="closed" &> /dev/null; then
            echo -e "${GREEN}✅ Created team: $team${NC}"
        else
            echo -e "${YELLOW}⚠️  Team $team may already exist or insufficient permissions${NC}"
        fi
    done
}

# Function to verify current protection status
verify_protection() {
    echo -e "\n${BOLD}🔍 Verifying branch protection status...${NC}"
    
    for branch in "main" "develop"; do
        if gh api repos/$REPO/branches/$branch/protection &> /dev/null; then
            echo -e "${GREEN}✅ $branch branch is protected${NC}"
            
            # Get protection details
            local reviews=$(gh api repos/$REPO/branches/$branch/protection --jq '.required_pull_request_reviews.required_approving_review_count // 0')
            local checks=$(gh api repos/$REPO/branches/$branch/protection --jq '.required_status_checks.contexts | length // 0')
            
            echo -e "   📊 Required reviews: $reviews"
            echo -e "   🔍 Required checks: $checks"
        else
            echo -e "${RED}❌ $branch branch is not protected${NC}"
        fi
    done
}

# Main execution
echo -e "\n${BOLD}🚀 Starting branch protection setup...${NC}"

# Apply branch protection rules
create_branch_protection "main" 2 true true "$MAIN_CHECKS" false false true
create_branch_protection "develop" 1 false false "$DEVELOP_CHECKS" false false false

# Enable security features
enable_security_features

# Create teams (optional - requires admin permissions)
read -p "Do you want to create repository teams? (requires org admin permissions) [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    create_teams
fi

# Verify the setup
verify_protection

echo -e "\n${BOLD}📋 Next Steps:${NC}"
echo "1. Manually create release/* and hotfix/* branch protection rules in GitHub UI"
echo "2. Configure repository rulesets in Settings → Rules → Rulesets"
echo "3. Assign team members to the created teams"
echo "4. Enable additional security features in Settings → Code security and analysis"
echo "5. Test the protection by creating a test PR"

echo -e "\n${GREEN}🎉 Branch protection setup completed!${NC}"
echo -e "${YELLOW}📖 For detailed configuration, see: .github/branch-protection-rules.md${NC}"

echo -e "\n${BOLD}🔗 Useful Commands:${NC}"
echo "• View branch protection: gh api repos/$REPO/branches/main/protection"
echo "• List repository teams: gh api orgs/bitcoin-enterprise-suite/teams"
echo "• Repository settings: https://github.com/$REPO/settings"