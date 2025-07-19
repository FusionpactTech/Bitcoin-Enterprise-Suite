# 🚀 Getting Started with Bitcoin Enterprise Suite

*Powered by [Fusionpact Technologies Inc.](https://fusionpact.com)*

Welcome to the Bitcoin Enterprise Suite! This guide will help you get up and running with our enterprise-grade Bitcoin infrastructure libraries in just a few minutes.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Rust 1.70+** - [Install via rustup](https://rustup.rs/)
- **Git** - For cloning repositories
- **C++ Compiler** - Required for some dependencies
  - **Linux/WSL**: `build-essential` package
  - **macOS**: Xcode Command Line Tools
  - **Windows**: Visual Studio Build Tools

## 🛠️ Installation

### Option 1: Add to Existing Rust Project

Add the libraries you need to your `Cargo.toml`:

```toml
[dependencies]
# Bitcoin Smart Contract Orchestration
biscol = "0.1.0"

# Cross-Chain Interoperability
cci-sat = "0.1.0"

# AI-Driven Compliance & Risk Management
aicrm-sdk = "0.1.0"

# Mining Operations & Energy Optimization
imo-eo = "0.1.0"
```

### Option 2: Clone and Build from Source

```bash
# Clone the repository
git clone https://github.com/FusionpactTech/Bitcoin-Enterprise-Suite.git
cd Bitcoin-Enterprise-Suite

# Build all libraries
cargo build --release --workspace

# Run tests to verify installation
cargo test --workspace
```

## 🎯 Quick Start Examples

### BiSCOL - Smart Contracts

```rust
use biscol::{SmartContract, ExecutionContext};

#[tokio::main]
async fn main() -> Result<(), biscol::Error> {
    // Create a new smart contract
    let contract = SmartContract::new();
    
    // Note: In production, configure with actual scripts and contexts
    println!("BiSCOL Smart Contract created successfully!");
    
    Ok(())
}
```

### CCI-SAT - Cross-Chain Operations

```rust
use cci_sat::{AtomicSwap, LightningChannel};

#[tokio::main]
async fn main() -> Result<(), cci_sat::Error> {
    // Create an atomic swap
    let swap = AtomicSwap::new();
    
    println!("CCI-SAT Atomic Swap initialized!");
    
    Ok(())
}
```

### AICRM-SDK - Risk Analysis

```rust
use aicrm_sdk::{RiskAnalyzer, ComplianceEngine};

#[tokio::main]
async fn main() -> Result<(), aicrm_sdk::Error> {
    // Create a risk analyzer
    let analyzer = RiskAnalyzer::new();
    
    println!("AICRM-SDK Risk Analyzer ready!");
    
    Ok(())
}
```

### IMO-EO - Mining Optimization

```rust
use imo_eo::{MiningOptimizer, EnergyMonitor};

#[tokio::main]
async fn main() -> Result<(), imo_eo::Error> {
    // Create a mining optimizer
    let optimizer = MiningOptimizer::new();
    
    println!("IMO-EO Mining Optimizer initialized!");
    
    Ok(())
}
```

## 🔧 Development Setup

### 1. Install Development Tools

```bash
# Install additional Rust tools
cargo install cargo-audit cargo-tarpaulin cargo-expand

# Install pre-commit hooks (optional)
pip install pre-commit
pre-commit install
```

### 2. IDE Configuration

#### VS Code (Recommended)
The repository includes VS Code workspace settings. Install these recommended extensions:

- **rust-analyzer** - Rust language support
- **CodeLLDB** - Debugging support
- **crates** - Dependency management
- **Error Lens** - Inline error highlighting

#### Other IDEs
- **IntelliJ IDEA**: Use the Rust plugin
- **Vim/Neovim**: Configure with rust-analyzer LSP
- **Emacs**: Use rustic-mode with rust-analyzer

### 3. Environment Variables

Create a `.env` file in your project root:

```bash
# Bitcoin network configuration
BITCOIN_NETWORK=testnet
BITCOIN_RPC_URL=http://localhost:18332
BITCOIN_RPC_USER=your_rpc_user
BITCOIN_RPC_PASSWORD=your_rpc_password

# Logging configuration
RUST_LOG=info
RUST_BACKTRACE=1

# Development settings
DEV_MODE=true
```

## 🌐 Network Configuration

### Bitcoin Testnet Setup

For development and testing, configure Bitcoin testnet:

```bash
# Install Bitcoin Core (example for Ubuntu)
sudo apt update
sudo apt install bitcoind

# Create bitcoin.conf
mkdir -p ~/.bitcoin
cat > ~/.bitcoin/bitcoin.conf << EOF
testnet=1
server=1
rpcuser=your_rpc_user
rpcpassword=your_secure_password
rpcallowip=127.0.0.1
EOF

# Start Bitcoin daemon
bitcoind -daemon
```

### Lightning Network (Optional)

For CCI-SAT Lightning features:

```bash
# Install LND (Lightning Network Daemon)
# Follow official installation guide at:
# https://docs.lightning.engineering/lightning-network-tools/lnd/installation
```

## 📊 First Integration Example

Here's a complete example integrating multiple libraries:

```rust
use tokio;
use biscol::SmartContract;
use cci_sat::AtomicSwap;
use aicrm_sdk::RiskAnalyzer;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("🟠 Bitcoin Enterprise Suite Integration Example");
    
    // Initialize risk analyzer
    let risk_analyzer = RiskAnalyzer::new();
    println!("✅ Risk Analyzer initialized");
    
    // Create smart contract
    let contract = SmartContract::new();
    println!("✅ Smart Contract created");
    
    // Initialize atomic swap
    let swap = AtomicSwap::new();
    println!("✅ Atomic Swap initialized");
    
    println!("🚀 All components ready for enterprise Bitcoin operations!");
    
    Ok(())
}
```

## 🧪 Testing Your Setup

Run the test suite to verify everything is working:

```bash
# Run all tests
cargo test --workspace

# Run tests for specific library
cargo test -p biscol

# Run with output
cargo test --workspace -- --nocapture

# Run benchmarks
cargo bench --workspace
```

## 📚 Next Steps

Now that you have Bitcoin Enterprise Suite set up:

1. **[📖 Complete Documentation](../README.md)** - Explore full documentation
2. **[🏗️ Architecture Guide](../architecture/overview.md)** - Understand system design
3. **[💡 Examples](../../examples/)** - Check practical examples
4. **[🔒 Security](../security/)** - Review security best practices
5. **[🤝 Contributing](../../CONTRIBUTING.md)** - Join our community

## 🆘 Troubleshooting

### Common Issues

#### Build Errors
```bash
# Update Rust
rustup update

# Clean build cache
cargo clean
cargo build --workspace
```

#### Dependency Issues
```bash
# Update dependencies
cargo update

# Check for security vulnerabilities
cargo audit
```

#### Performance Issues
```bash
# Build with optimizations
cargo build --release --workspace

# Profile your application
cargo install flamegraph
cargo flamegraph --your-binary
```

## 📞 Support

Need help? Contact us:

- **[💬 Discord](https://discord.gg/ZK5n8A8B)** - Real-time community support
- **[📧 General Questions](mailto:Hello@fusionpact.com)** - General inquiries
- **[🏢 Enterprise Support](mailto:Enterprise@fusionpact.com)** - Enterprise solutions
- **[🔒 Security Issues](mailto:Security@fusionpact.com)** - Security vulnerabilities

---

<div align="center">
  <strong>Welcome to the future of enterprise Bitcoin development!</strong>
  <br>
  <sub>Powered by Fusionpact Technologies Inc.</sub>
</div>