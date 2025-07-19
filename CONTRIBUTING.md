# Contributing to Bitcoin Enterprise Suite

Thank you for your interest in contributing to the Bitcoin Enterprise Suite! This guide will help you get started with contributing to our open-source Bitcoin infrastructure libraries.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Security](#security)
- [Pull Request Process](#pull-request-process)
- [Community](#community)

## 🤝 Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](./docs/CODE_OF_CONDUCT.md). We are committed to providing a welcoming and inclusive environment for all contributors.

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:

- **Rust 1.70+** installed via [rustup](https://rustup.rs/)
- **Git** for version control
- **Docker** (optional) for containerized development
- **Node.js 18+** (for documentation generation)

### Development Environment Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/bitcoin-enterprise-suite.git
   cd bitcoin-enterprise-suite
   ```

2. **Install Development Tools**
   ```bash
   # Rust development tools
   cargo install cargo-audit cargo-tarpaulin cargo-expand cargo-outdated
   
   # Pre-commit hooks
   pip install pre-commit
   pre-commit install
   ```

3. **Build and Test**
   ```bash
   # Build all libraries
   cargo build --workspace
   
   # Run all tests
   cargo test --workspace
   
   # Check code formatting
   cargo fmt --all -- --check
   
   # Run linting
   cargo clippy --workspace -- -D warnings
   ```

## 🔄 Development Workflow

### Branch Naming Convention

Use descriptive branch names following this pattern:
- `feature/library-name/description` - New features
- `fix/library-name/description` - Bug fixes
- `docs/description` - Documentation updates
- `refactor/library-name/description` - Code refactoring
- `test/library-name/description` - Test improvements

### Commit Message Format

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(biscol): add taproot script execution support

fix(cci-sat): resolve lightning network channel state sync issue

docs: update API documentation for AICRM risk scoring

test(imo-eo): add integration tests for energy optimization
```

## 📝 Coding Standards

### Rust Guidelines

1. **Code Style**
   - Use `cargo fmt` for consistent formatting
   - Follow the [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
   - Use meaningful variable and function names
   - Add comprehensive documentation comments (`///`)

2. **Error Handling**
   - Use `Result<T, E>` for fallible operations
   - Create custom error types using `thiserror`
   - Provide helpful error messages with context

3. **Performance**
   - Avoid unnecessary allocations
   - Use zero-copy patterns where possible
   - Profile critical paths and optimize bottlenecks

4. **Security**
   - Never expose private keys or sensitive data in logs
   - Use constant-time algorithms for cryptographic operations
   - Validate all inputs thoroughly

### Code Organization

- **Modules**: Use clear module hierarchies with public/private separation
- **Dependencies**: Minimize external dependencies and justify each addition
- **Configuration**: Use structured configuration with validation
- **Logging**: Use `tracing` crate with appropriate log levels

## 🧪 Testing Guidelines

### Test Structure

1. **Unit Tests**
   - Test individual functions and methods in isolation
   - Place tests in the same file as the code they test
   - Use descriptive test names that explain the scenario

2. **Integration Tests**
   - Test interactions between components
   - Place in `tests/` directory within each library
   - Mock external dependencies appropriately

3. **End-to-End Tests**
   - Test complete workflows across libraries
   - Use realistic test data and scenarios
   - Include performance benchmarks

### Test Requirements

- **Coverage**: Maintain >95% code coverage
- **Documentation**: Test critical edge cases and error conditions
- **Performance**: Include benchmark tests for performance-critical code
- **Security**: Test security-related functionality thoroughly

### Running Tests

```bash
# Run all tests
cargo test --workspace

# Run tests with coverage
cargo tarpaulin --workspace --out Html

# Run specific library tests
cargo test -p biscol

# Run benchmarks
cargo bench --workspace
```

## 📚 Documentation

### API Documentation

- Use `///` for public APIs with examples
- Include usage examples in doc comments
- Document all public types, functions, and modules
- Use `cargo doc` to generate and verify documentation

### User Documentation

- Update relevant documentation in `/docs`
- Include practical examples in `/examples`
- Update changelog for breaking changes
- Ensure all links work correctly

### Documentation Standards

```rust
/// Executes a Bitcoin script with the given parameters.
///
/// This function validates and executes Bitcoin scripts using the Taproot
/// execution environment, providing enhanced privacy and efficiency.
///
/// # Arguments
///
/// * `script` - The Bitcoin script to execute
/// * `context` - Execution context including stack and witness data
///
/// # Returns
///
/// Returns `Ok(ExecutionResult)` on successful execution, or an error
/// if the script fails validation or execution.
///
/// # Examples
///
/// ```rust
/// use biscol::{Script, ExecutionContext, execute_script};
///
/// let script = Script::from_hex("OP_DUP OP_HASH160")?;
/// let context = ExecutionContext::new();
/// let result = execute_script(&script, &context)?;
/// ```
///
/// # Security Considerations
///
/// - Scripts are executed in a sandboxed environment
/// - All operations are bounds-checked
/// - Timeouts prevent infinite loops
pub fn execute_script(script: &Script, context: &ExecutionContext) -> Result<ExecutionResult, ScriptError> {
    // Implementation...
}
```

## 🔒 Security

### Security-First Development

1. **Threat Modeling**
   - Consider attack vectors during design
   - Document security assumptions
   - Regular security reviews

2. **Secure Coding Practices**
   - Input validation and sanitization
   - Proper error handling without information leakage
   - Secure randomness generation

3. **Dependency Management**
   - Regular security audits with `cargo audit`
   - Pin dependency versions
   - Review security advisories

### Reporting Security Issues

**DO NOT** open public issues for security vulnerabilities. Instead:

1. Email: [Security@fusionpact.com](mailto:Security@fusionpact.com)
2. Include detailed description and reproduction steps
3. Allow reasonable time for response before public disclosure

## 🔄 Pull Request Process

### Before Submitting

1. **Checklist**
   - [ ] Code compiles without warnings
   - [ ] All tests pass
   - [ ] Code coverage maintained >95%
   - [ ] Documentation updated
   - [ ] Security review completed
   - [ ] Performance impact assessed

2. **Pre-commit Validation**
   ```bash
   # Format code
   cargo fmt --all
   
   # Run linting
   cargo clippy --workspace -- -D warnings
   
   # Run security audit
   cargo audit
   
   # Run tests
   cargo test --workspace
   ```

### Pull Request Template

Use our [PR template](./.github/PULL_REQUEST_TEMPLATE/pull_request_template.md) which includes:

- **Description**: Clear explanation of changes
- **Type**: Feature, fix, docs, etc.
- **Testing**: How changes were tested
- **Breaking Changes**: Any backward compatibility impacts
- **Checklist**: Verification of requirements

### Review Process

1. **Automated Checks**: CI/CD pipeline validates code quality
2. **Peer Review**: At least two maintainer approvals required
3. **Security Review**: Security-sensitive changes require security team review
4. **Documentation Review**: Documentation changes reviewed by docs team

## 🌟 Community

### Communication Channels

- **GitHub Discussions**: General questions and feature discussions
- **Discord**: Real-time developer chat and support
- **Twitter**: Announcements and updates
- **Email**: Security@fusionpact.com for security issues

### Recognition

We recognize contributors through:
- **Contributor Hall of Fame** in our documentation
- **Monthly Contributor Spotlight** in our newsletter
- **Conference Speaking Opportunities** for major contributors
- **Swag and Rewards** for consistent contributors

### Mentorship Program

New contributors can participate in our mentorship program:
- Paired with experienced maintainers
- Structured onboarding process
- Regular check-ins and guidance
- Focus on both technical and community skills

## 📈 Contribution Areas

### High-Impact Contributions

1. **Core Library Development**
   - Implementing new Bitcoin protocols
   - Performance optimizations
   - Security enhancements

2. **Documentation**
   - API documentation improvements
   - Tutorial creation
   - Example applications

3. **Testing**
   - Increasing test coverage
   - Performance benchmarking
   - Security testing

4. **Developer Experience**
   - Tooling improvements
   - Error message enhancement
   - IDE integration

### Good First Issues

Look for issues labeled:
- `good-first-issue`: Suitable for newcomers
- `help-wanted`: Community help needed
- `documentation`: Documentation improvements
- `testing`: Test coverage improvements

## 📞 Getting Help

If you need help:

1. **Search existing issues** and discussions
2. **Join our Discord** for real-time help
3. **Open a discussion** for design questions
4. **Open an issue** for bugs or feature requests

---

Thank you for contributing to the Bitcoin Enterprise Suite! Your contributions help build the future of enterprise Bitcoin infrastructure.

**Happy coding! 🚀**