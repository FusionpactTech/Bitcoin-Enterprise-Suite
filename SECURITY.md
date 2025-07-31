# Security Policy

## 🚨 Reporting Security Vulnerabilities

**⚠️ CRITICAL: Do NOT report security vulnerabilities through public GitHub issues.**

For complete security information and detailed policies, please see our comprehensive [Security Documentation](./docs/security/SECURITY.md).

### Quick Contact Information

- **Security Email**: [Security@fusionpact.com](mailto:Security@fusionpact.com)
- **Response Time**: Within 24 hours
- **PGP Key**: Available at [https://bitcoin-enterprise-suite.org/security.asc](https://bitcoin-enterprise-suite.org/security.asc)

### Severity Levels

| Severity | Response Time |
|----------|---------------|
| **Critical** | 24 hours |
| **High** | 72 hours |
| **Medium** | 7 days |
| **Low** | 30 days |

## 🔒 Security Features

- **Automated Dependency Scanning**: Dependabot enabled for all dependencies
- **Security Audits**: Regular third-party security audits
- **Vulnerability Database**: Continuous monitoring with `cargo audit`
- **Supply Chain Security**: Signed releases and reproducible builds

## 📋 Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |
| < 0.1   | :x:                |

## 🛡️ Security Best Practices

1. **Always use the latest version** of the Bitcoin Enterprise Suite libraries
2. **Enable dependency scanning** in your projects using our libraries
3. **Follow secure coding practices** outlined in our documentation
4. **Implement proper key management** for production deployments
5. **Regular security updates** - subscribe to our security announcements

## 📚 Additional Resources

- **[Latest Security Audit Report](./docs/security/security-audit-2025-01.md)** - January 2025 comprehensive security assessment
- **[Complete Security Policy](./docs/security/SECURITY.md)** - Detailed security practices and procedures
- **[Security Architecture](./docs/architecture/security.md)** - Security design principles
- **[Audit Reports](./docs/security/audit-reports.md)** - Historical security audit results
- **[Cryptographic Specifications](./docs/security/cryptography.md)** - Cryptographic implementation details

## 🔍 Recent Security Updates (January 2025)

### ✅ Critical Vulnerabilities Resolved
- **RUSTSEC-2024-0437**: Protobuf vulnerability fixed (upgraded to v3.7.2)
- **Unmaintained Dependencies**: Replaced yaml-rust with serde_yaml
- **Configuration Issues**: Fixed cargo deny configuration

### 🔒 New Security Features
- **Container Security**: Production Dockerfile with security hardening
- **Enhanced Secret Scanning**: Bitcoin-specific pattern detection
- **Reproducible Builds**: Deterministic build verification
- **Trivy Integration**: Container vulnerability scanning

### 📊 Current Security Status
**Overall Rating**: A+ (95/100) ✅ SECURE

For detailed findings and remediation steps, see the [latest audit report](./docs/security/security-audit-2025-01.md).

---

<div align="center">
  <strong>🔒 Security is everyone's responsibility</strong>
  <br>
  <sub>Help us keep the Bitcoin Enterprise Suite secure for the entire ecosystem</sub>
</div>