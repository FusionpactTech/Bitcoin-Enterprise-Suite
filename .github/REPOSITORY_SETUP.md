# 🛡️ Repository Setup Guide - Quick Reference

This guide provides step-by-step instructions for repository administrators to apply the comprehensive branch protection rules and security configurations for the Bitcoin Enterprise Suite.

## 🎯 Quick Setup Checklist

### ✅ Phase 1: Automated Setup (5 minutes)

1. **Run the Setup Script**
   ```bash
   ./scripts/setup-branch-protection.sh
   ```

2. **Verify CODEOWNERS File**
   - File should exist at `.github/CODEOWNERS`
   - Contains team assignments for different parts of the codebase

3. **Check Dependabot Configuration**
   - File should exist at `.github/dependabot.yml`
   - Enables automated dependency updates and security alerts

### ✅ Phase 2: Manual GitHub UI Configuration (10 minutes)

#### 1. Repository Settings
Navigate to `Settings` → `General`:

**Merge Button Settings:**
- ❌ Allow merge commits
- ✅ Allow squash merging (default)
- ✅ Allow rebase merging
- ✅ Always suggest updating pull request branches
- ❌ Allow auto-merge
- ✅ Automatically delete head branches

#### 2. Security & Analysis
Navigate to `Settings` → `Code security and analysis`:

**Enable All Security Features:**
- ✅ Dependency graph
- ✅ Dependabot alerts  
- ✅ Dependabot security updates
- ✅ Dependabot version updates
- ✅ Code scanning alerts
- ✅ Secret scanning alerts
- ✅ Secret scanning push protection

#### 3. Create Repository Teams
Navigate to `Organization Settings` → `Teams`:

**Required Teams:**
- `maintainers` (Admin access)
- `security-team` (Maintain access)  
- `biscol-team` (Write access)
- `cci-sat-team` (Write access)
- `aicrm-team` (Write access)
- `imo-eo-team` (Write access)
- `docs-team` (Write access)
- `devops-team` (Write access)
- `contributors` (Triage access)

#### 4. Additional Branch Protection Rules
Navigate to `Settings` → `Branches`:

**Create Protection Rules for:**

**Release Branches (`release/*`):**
```
Required status checks: ✅ (strict)
- CI/CD Pipeline / code-quality
- CI/CD Pipeline / test (ubuntu-latest, stable)
- CI/CD Pipeline / test (windows-latest, stable)
- CI/CD Pipeline / test (macos-latest, stable)
- CI/CD Pipeline / build-release
- Security Checks / dependency-audit
- Security Checks / vulnerability-scanning
- Security Checks / reproducible-builds

Require pull request reviews: ✅
- Required approving reviews: 2
- Dismiss stale reviews: ✅
- Require review from code owners: ✅
- Require approval of the most recent push: ✅
- Require conversation resolution: ✅

Enforce restrictions: ✅
- Force pushes: ❌
- Deletions: ❌
- Linear history: ✅
```

**Hotfix Branches (`hotfix/*`):**
```
Required status checks: ✅ (strict)
- CI/CD Pipeline / code-quality
- CI/CD Pipeline / test (ubuntu-latest, stable)
- Security Checks / dependency-audit
- Security Checks / secret-scanning

Require pull request reviews: ✅
- Required approving reviews: 1
- Dismiss stale reviews: ✅
- Require review from code owners: ✅
- Require conversation resolution: ✅

Bypass options: security-team, maintainers
```

### ✅ Phase 3: Repository Rulesets (5 minutes)

Navigate to `Settings` → `Rules` → `Rulesets`:

#### 1. Create "Security Rules" Ruleset
```json
{
  "name": "Bitcoin Enterprise Suite Security Rules",
  "enforcement": "active",
  "target": "branch",
  "conditions": {
    "ref_name": {
      "include": ["**"],
      "exclude": ["refs/heads/feature/**", "refs/heads/bugfix/**"]
    }
  },
  "rules": [
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 1,
        "dismiss_stale_reviews_on_push": true,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": true
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "required_status_checks": [
          {"context": "Security Checks / dependency-audit"},
          {"context": "Security Checks / secret-scanning"}
        ],
        "strict_required_status_checks_policy": true
      }
    },
    {
      "type": "non_fast_forward"}
  ]
}
```

#### 2. Create "Critical Branch Protection" Ruleset
```json
{
  "name": "Critical Branch Protection",
  "enforcement": "active",
  "target": "branch",
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main", "refs/heads/release/**"]
    }
  },
  "rules": [
    {"type": "deletion"},
    {"type": "non_fast_forward"},
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 2,
        "dismiss_stale_reviews_on_push": true,
        "require_code_owner_review": true,
        "require_last_push_approval": true,
        "required_review_thread_resolution": true
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "required_status_checks": [
          {"context": "CI/CD Pipeline / code-quality"},
          {"context": "CI/CD Pipeline / test (ubuntu-latest, stable)"},
          {"context": "CI/CD Pipeline / test (windows-latest, stable)"},
          {"context": "CI/CD Pipeline / test (macos-latest, stable)"},
          {"context": "Security Checks / dependency-audit"},
          {"context": "Security Checks / cargo-deny"},
          {"context": "Security Checks / secret-scanning"},
          {"context": "Security Checks / vulnerability-scanning"},
          {"context": "Security Checks / sast-analysis"}
        ],
        "strict_required_status_checks_policy": true
      }
    },
    {"type": "required_linear_history"}
  ]
}
```

## 🧪 Testing the Configuration

### Test 1: Direct Push Protection
```bash
# This should fail
git push origin main
```
Expected: `Push declined due to repository rule violations`

### Test 2: PR Without Reviews
1. Create a feature branch
2. Make changes and create PR to main
3. Try to merge without reviews

Expected: Merge blocked until required reviews obtained

### Test 3: Security Check Failures
1. Create PR with failing security checks
2. Attempt to merge

Expected: Merge blocked until all status checks pass

## 🔍 Verification Commands

```bash
# Check branch protection status
gh api repos/bitcoin-enterprise-suite/bitcoin-enterprise-suite/branches/main/protection

# List repository rulesets
gh api repos/bitcoin-enterprise-suite/bitcoin-enterprise-suite/rulesets

# View security features
gh api repos/bitcoin-enterprise-suite/bitcoin-enterprise-suite/vulnerability-alerts

# Check team permissions
gh api orgs/bitcoin-enterprise-suite/teams
```

## 📊 Monitoring and Maintenance

### Weekly Checks
- [ ] Review failed security scans
- [ ] Check Dependabot PRs
- [ ] Verify branch protection effectiveness

### Monthly Reviews  
- [ ] Audit team permissions
- [ ] Review bypass usage
- [ ] Update protection rules if needed

### Quarterly Audits
- [ ] Full security configuration review
- [ ] Team membership audit
- [ ] Rule effectiveness analysis

## 🚨 Emergency Procedures

### Security Incident Response
1. **Critical Security Fix Required:**
   - Security team can bypass reviews
   - Document bypass reason in PR
   - Follow up with security review

2. **Branch Protection Issues:**
   - Contact repository admins
   - Document any emergency bypasses
   - Restore protection immediately after fix

### Rollback Procedure
If configuration causes issues:

1. **Disable Problematic Rules:**
   ```bash
   gh api repos/bitcoin-enterprise-suite/bitcoin-enterprise-suite/branches/main/protection --method DELETE
   ```

2. **Reapply Basic Protection:**
   ```bash
   ./scripts/setup-branch-protection.sh
   ```

## 📞 Support Contacts

- **Repository Admin**: [admin@bitcoin-enterprise-suite.org](mailto:admin@bitcoin-enterprise-suite.org)
- **Security Team**: [security@bitcoin-enterprise-suite.org](mailto:security@bitcoin-enterprise-suite.org)
- **DevOps Team**: [devops@bitcoin-enterprise-suite.org](mailto:devops@bitcoin-enterprise-suite.org)

## 📚 Reference Documentation

- [Branch Protection Rules Guide](.github/branch-protection-rules.md)
- [Security Workflow Documentation](.github/workflows/security.yml)
- [CODEOWNERS Configuration](.github/CODEOWNERS)
- [Dependabot Configuration](.github/dependabot.yml)

---

## ✅ Configuration Complete

Once all steps are completed, your repository will have:

- 🛡️ **Comprehensive branch protection** for main, develop, release, and hotfix branches
- 🔐 **Multi-layered security scanning** with automated dependency updates
- 👥 **Team-based code ownership** with required reviewers
- 📊 **Repository rulesets** enforcing consistent policies
- 🚨 **Emergency procedures** for security incidents
- 📈 **Monitoring and compliance** tracking

The Bitcoin Enterprise Suite repository is now protected with enterprise-grade security and development practices.

---

<div align="center">
  <strong>🛡️ Your repository is now secure and ready for enterprise development!</strong>
</div>