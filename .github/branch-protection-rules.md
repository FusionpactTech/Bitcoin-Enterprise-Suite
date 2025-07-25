# 🛡️ Branch Protection Rules for Bitcoin Enterprise Suite

This document outlines the recommended branch protection rules and repository rulesets for maintaining security and code quality in the Bitcoin Enterprise Suite repository.

## 🎯 Overview

Branch protection rules are essential for maintaining code quality, security, and preventing accidental changes to critical branches in financial infrastructure projects. These rules enforce best practices and ensure all changes go through proper review processes.

## 🌿 Branch Structure

### Protected Branches

- **`main`** - Production-ready code, highest protection level
- **`develop`** - Integration branch for feature development
- **`release/*`** - Release preparation branches
- **`hotfix/*`** - Critical bug fixes for production

### Development Branches

- **`feature/*`** - New feature development (no protection)
- **`bugfix/*`** - Non-critical bug fixes (no protection)
- **`docs/*`** - Documentation updates (light protection)

## 🔒 Main Branch Protection Rules

### Required Settings for `main` Branch

```json
{
  "protection": {
    "required_status_checks": {
      "strict": true,
      "contexts": [
        "CI/CD Pipeline / code-quality",
        "CI/CD Pipeline / test (ubuntu-latest, stable)",
        "CI/CD Pipeline / test (windows-latest, stable)",
        "CI/CD Pipeline / test (macos-latest, stable)",
        "Security Checks / dependency-audit",
        "Security Checks / cargo-deny",
        "Security Checks / secret-scanning",
        "Security Checks / vulnerability-scanning",
        "Security Checks / license-check",
        "Security Checks / supply-chain-security",
        "Security Checks / sast-analysis"
      ]
    },
    "enforce_admins": true,
    "required_pull_request_reviews": {
      "required_approving_review_count": 2,
      "dismiss_stale_reviews": true,
      "require_code_owner_reviews": true,
      "require_last_push_approval": true,
      "bypass_pull_request_allowances": {
        "users": [],
        "teams": ["security-team"],
        "apps": []
      }
    },
    "restrictions": {
      "users": [],
      "teams": ["maintainers", "security-team"],
      "apps": ["dependabot"]
    },
    "required_linear_history": true,
    "allow_force_pushes": false,
    "allow_deletions": false,
    "block_creations": false,
    "required_conversation_resolution": true,
    "lock_branch": false,
    "allow_fork_syncing": false
  }
}
```

### Key Features:

✅ **Require 2+ approving reviews**
✅ **Require code owner approval**
✅ **Dismiss stale reviews on new commits**
✅ **Require up-to-date branches**
✅ **Enforce linear history (no merge commits)**
✅ **Block force pushes and deletions**
✅ **Require conversation resolution**
✅ **Comprehensive CI/CD checks**
✅ **Security scan requirements**

## 🔧 Develop Branch Protection Rules

### Required Settings for `develop` Branch

```json
{
  "protection": {
    "required_status_checks": {
      "strict": true,
      "contexts": [
        "CI/CD Pipeline / code-quality",
        "CI/CD Pipeline / test (ubuntu-latest, stable)",
        "Security Checks / dependency-audit",
        "Security Checks / cargo-deny",
        "Security Checks / secret-scanning"
      ]
    },
    "enforce_admins": false,
    "required_pull_request_reviews": {
      "required_approving_review_count": 1,
      "dismiss_stale_reviews": true,
      "require_code_owner_reviews": false,
      "require_last_push_approval": false
    },
    "restrictions": null,
    "required_linear_history": false,
    "allow_force_pushes": false,
    "allow_deletions": false,
    "required_conversation_resolution": true
  }
}
```

## 🚀 Release Branch Protection Rules

### Required Settings for `release/*` Branches

```json
{
  "protection": {
    "required_status_checks": {
      "strict": true,
      "contexts": [
        "CI/CD Pipeline / code-quality",
        "CI/CD Pipeline / test (ubuntu-latest, stable)",
        "CI/CD Pipeline / test (windows-latest, stable)",
        "CI/CD Pipeline / test (macos-latest, stable)",
        "CI/CD Pipeline / build-release",
        "Security Checks / dependency-audit",
        "Security Checks / vulnerability-scanning",
        "Security Checks / reproducible-builds"
      ]
    },
    "enforce_admins": true,
    "required_pull_request_reviews": {
      "required_approving_review_count": 2,
      "dismiss_stale_reviews": true,
      "require_code_owner_reviews": true,
      "require_last_push_approval": true
    },
    "required_linear_history": true,
    "allow_force_pushes": false,
    "allow_deletions": false,
    "required_conversation_resolution": true
  }
}
```

## 🔥 Hotfix Branch Protection Rules

### Required Settings for `hotfix/*` Branches

```json
{
  "protection": {
    "required_status_checks": {
      "strict": true,
      "contexts": [
        "CI/CD Pipeline / code-quality",
        "CI/CD Pipeline / test (ubuntu-latest, stable)",
        "Security Checks / dependency-audit",
        "Security Checks / secret-scanning"
      ]
    },
    "enforce_admins": false,
    "required_pull_request_reviews": {
      "required_approving_review_count": 1,
      "dismiss_stale_reviews": true,
      "require_code_owner_reviews": true,
      "require_last_push_approval": false,
      "bypass_pull_request_allowances": {
        "teams": ["security-team", "maintainers"]
      }
    },
    "required_linear_history": false,
    "allow_force_pushes": false,
    "allow_deletions": false,
    "required_conversation_resolution": true
  }
}
```

## 👥 Required Teams and Roles

### Teams to Create

1. **`maintainers`**
   - Core maintainers with admin access
   - Can bypass some protections for hotfixes
   - Members: Core development team leads

2. **`security-team`**
   - Security specialists
   - Can bypass reviews for security fixes
   - Members: Security engineers and auditors

3. **`code-owners`**
   - Domain experts for specific libraries
   - Required for code owner reviews
   - Members: Library maintainers

4. **`contributors`**
   - External contributors
   - Standard contribution permissions
   - Members: Community contributors

## 📝 CODEOWNERS Configuration

Create `.github/CODEOWNERS` file:

```bash
# Global code owners
* @bitcoin-enterprise-suite/maintainers

# Security-related files
SECURITY.md @bitcoin-enterprise-suite/security-team
.github/workflows/security.yml @bitcoin-enterprise-suite/security-team
.github/dependabot.yml @bitcoin-enterprise-suite/security-team
deny.toml @bitcoin-enterprise-suite/security-team
docs/security/ @bitcoin-enterprise-suite/security-team

# Library-specific owners
libs/biscol/ @bitcoin-enterprise-suite/biscol-team @bitcoin-enterprise-suite/maintainers
libs/cci-sat/ @bitcoin-enterprise-suite/cci-sat-team @bitcoin-enterprise-suite/maintainers
libs/aicrm-sdk/ @bitcoin-enterprise-suite/aicrm-team @bitcoin-enterprise-suite/maintainers
libs/imo-eo/ @bitcoin-enterprise-suite/imo-eo-team @bitcoin-enterprise-suite/maintainers

# Documentation
docs/ @bitcoin-enterprise-suite/docs-team @bitcoin-enterprise-suite/maintainers
*.md @bitcoin-enterprise-suite/docs-team

# CI/CD and Infrastructure
.github/ @bitcoin-enterprise-suite/devops-team @bitcoin-enterprise-suite/maintainers
Dockerfile* @bitcoin-enterprise-suite/devops-team
docker-compose.yml @bitcoin-enterprise-suite/devops-team

# Configuration files
Cargo.toml @bitcoin-enterprise-suite/maintainers
Cargo.lock @bitcoin-enterprise-suite/maintainers
```

## 🔐 Repository Settings

### General Repository Settings

```yaml
Repository Settings:
  # Basic Settings
  - Allow merge commits: false
  - Allow squash merging: true
  - Allow rebase merging: true
  - Always suggest updating pull request branches: true
  - Allow auto-merge: false
  - Automatically delete head branches: true
  
  # Pull Request Settings
  - Allow squash merging: true
    - Default to pull request title for squash merge commits
  - Allow rebase merging: true
  - Always suggest updating pull request branches: true
  
  # Security Settings
  - Private vulnerability reporting: enabled
  - Dependency graph: enabled
  - Dependabot alerts: enabled
  - Dependabot security updates: enabled
  - Dependabot version updates: enabled
  - Code scanning alerts: enabled
  - Secret scanning alerts: enabled
  - Secret scanning push protection: enabled
```

### Security & Analysis Settings

```yaml
Security & Analysis:
  # Dependency Graph
  - enabled: true
  
  # Dependabot
  - dependabot_alerts: enabled
  - dependabot_security_updates: enabled
  - dependabot_version_updates: enabled
  
  # Code Scanning
  - code_scanning_default_setup: enabled
  - code_scanning_default_query_suite: extended
  
  # Secret Scanning
  - secret_scanning: enabled
  - secret_scanning_push_protection: enabled
  - secret_scanning_validity_checks: enabled
```

## 🎯 Ruleset Configuration

### Repository Ruleset for All Branches

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
          {
            "context": "Security Checks / dependency-audit",
            "integration_id": null
          },
          {
            "context": "Security Checks / secret-scanning",
            "integration_id": null
          }
        ],
        "strict_required_status_checks_policy": true
      }
    },
    {
      "type": "non_fast_forward",
      "parameters": {}
    }
  ],
  "bypass_actors": [
    {
      "actor_id": 1,
      "actor_type": "Team",
      "bypass_mode": "pull_request"
    }
  ]
}
```

### Critical Branch Ruleset (main, release/*)

```json
{
  "name": "Critical Branch Protection",
  "enforcement": "active",
  "target": "branch",
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main", "refs/heads/release/**"],
      "exclude": []
    }
  },
  "rules": [
    {
      "type": "deletion",
      "parameters": {}
    },
    {
      "type": "non_fast_forward",
      "parameters": {}
    },
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
    {
      "type": "required_linear_history",
      "parameters": {}
    }
  ],
  "bypass_actors": []
}
```

## 🛠️ Implementation Steps

### Step 1: Create Teams

1. Go to `Settings` → `Access` → `Manage access`
2. Create the following teams:
   - `maintainers` (Admin access)
   - `security-team` (Maintain access)
   - `biscol-team`, `cci-sat-team`, `aicrm-team`, `imo-eo-team` (Write access)
   - `docs-team`, `devops-team` (Write access)
   - `contributors` (Triage access)

### Step 2: Configure CODEOWNERS

1. Create `.github/CODEOWNERS` file with the content above
2. Commit to the main branch

### Step 3: Apply Branch Protection Rules

1. Go to `Settings` → `Branches`
2. Add branch protection rules for:
   - `main` (use the main branch configuration)
   - `develop` (use the develop branch configuration)
   - `release/*` (use the release branch configuration)
   - `hotfix/*` (use the hotfix branch configuration)

### Step 4: Configure Repository Rulesets

1. Go to `Settings` → `Rules` → `Rulesets`
2. Create "Bitcoin Enterprise Suite Security Rules" ruleset
3. Create "Critical Branch Protection" ruleset
4. Apply the JSON configurations above

### Step 5: Enable Security Features

1. Go to `Settings` → `Code security and analysis`
2. Enable all security features as listed in the configuration

### Step 6: Verify Protection

Test the protection by:
1. Attempting to push directly to main (should fail)
2. Creating a PR with failing checks (should be blocked)
3. Creating a PR without required reviewers (should be blocked)

## 📊 Monitoring and Compliance

### Security Metrics to Track

- Failed push attempts to protected branches
- Number of security scan failures
- Time to resolve security vulnerabilities
- Compliance with review requirements

### Regular Reviews

- Monthly review of branch protection effectiveness
- Quarterly audit of team permissions
- Annual review of ruleset configurations

## 🚨 Emergency Procedures

### Security Incident Response

In case of security incidents:

1. **Critical Security Fix**:
   - Security team can bypass reviews for urgent fixes
   - Document the bypass reason
   - Follow up with post-incident review

2. **Branch Corruption**:
   - Only repository admins can force-push to protected branches
   - Requires approval from 2+ maintainers
   - Must document the reason and impact

## 📋 Compliance Checklist

- [ ] All critical branches are protected
- [ ] Required status checks are enforced
- [ ] Code owner reviews are mandatory
- [ ] Security scans are required
- [ ] Linear history is enforced on main
- [ ] Force pushes are blocked
- [ ] Branch deletions are blocked
- [ ] Conversation resolution is required
- [ ] Teams and permissions are configured
- [ ] CODEOWNERS file is in place
- [ ] Emergency procedures are documented

---

## 📞 Support

For questions about branch protection or repository security:

- **Security Team**: [security@bitcoin-enterprise-suite.org](mailto:security@bitcoin-enterprise-suite.org)
- **DevOps Team**: [devops@bitcoin-enterprise-suite.org](mailto:devops@bitcoin-enterprise-suite.org)
- **Documentation**: [Repository Settings Guide](./repository-settings.md)

---

<div align="center">
  <strong>🛡️ Secure development practices protect everyone</strong>
  <br>
  <sub>These rules ensure code quality and security for the Bitcoin ecosystem</sub>
</div>