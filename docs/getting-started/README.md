# 🚀 Getting Started with Bitcoin Enterprise Suite

Welcome to the Bitcoin Enterprise Suite! This guide will help you get up and running quickly with our enterprise-grade Bitcoin infrastructure libraries.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

### Required Software

```bash
# Rust 1.70 or later
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustc --version  # Should be 1.70+

# Git (for cloning repositories)
git --version

# Docker (optional, for containerized development)
docker --version
```

### Bitcoin Node Setup (Recommended)

For full functionality, we recommend running a Bitcoin node:

```bash
# Using Bitcoin Core (recommended)
# Download from https://bitcoincore.org/en/download/

# Or using Docker
docker run -d \
  --name bitcoin-node \
  -p 8332:8332 \
  -p 8333:8333 \
  -v bitcoin-data:/root/.bitcoin \
  bitcoin/bitcoin:latest \
  bitcoind -server -rpcuser=bitcoinrpc -rpcpassword=changeme123
```

## 🏃‍♂️ Quick Start

### Option 1: Clone the Full Suite

```bash
# Clone the repository
git clone https://github.com/bitcoin-enterprise-suite/bitcoin-enterprise-suite.git
cd bitcoin-enterprise-suite

# Build all libraries
cargo build --workspace

# Run tests to verify installation
cargo test --workspace

# Build documentation
cargo doc --workspace --no-deps --open
```

### Option 2: Use Individual Libraries

Add specific libraries to your `Cargo.toml`:

```toml
[dependencies]
# Choose the libraries you need
biscol = "0.1.0"        # Smart contracts
cci-sat = "0.1.0"       # Cross-chain transfers
aicrm-sdk = "0.1.0"     # Compliance & risk
imo-eo = "0.1.0"        # Mining optimization

# Common dependencies
tokio = { version = "1.0", features = ["full"] }
serde = { version = "1.0", features = ["derive"] }
```

## 🔧 Environment Setup

### 1. Configuration File

Create a configuration file for your environment:

```toml
# bitcoin-enterprise.toml
[bitcoin]
network = "testnet"  # testnet, mainnet, regtest
rpc_url = "http://localhost:18332"
rpc_user = "bitcoinrpc"
rpc_password = "changeme123"

[security]
enable_audit_logging = true
strict_validation = true
enable_encryption = true

[performance]
worker_threads = 4
cache_size = 1000
timeout_seconds = 30
```

### 2. Environment Variables

Set up your environment variables:

```bash
# Create .env file
cat > .env << 'EOF'
# Bitcoin Network Configuration
BITCOIN_NETWORK=testnet
BITCOIN_RPC_URL=http://localhost:18332
BITCOIN_RPC_USER=bitcoinrpc
BITCOIN_RPC_PASSWORD=changeme123

# Security Settings
ENABLE_AUDIT_LOGGING=true
STRICT_VALIDATION=true
LOG_LEVEL=info

# Performance Tuning
WORKER_THREADS=4
CACHE_SIZE=1000
TIMEOUT_SECONDS=30
EOF

# Load environment variables
source .env
```

## 📚 Library-Specific Quick Starts

### 🔐 BiSCOL - Smart Contracts

Create your first smart contract:

```rust
use biscol::prelude::*;
use bitcoin::secp256k1::Secp256k1;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize BiSCOL
    let secp = Secp256k1::new();
    let config = BiSCOLConfig::from_env()?;
    let orchestrator = ContractOrchestrator::new(config, &secp).await?;
    
    // Create a simple escrow contract
    let escrow = EscrowContract::builder()
        .buyer_pubkey(buyer_key)
        .seller_pubkey(seller_key)
        .arbiter_pubkey(arbiter_key)
        .amount(100_000) // satoshis
        .timeout_blocks(144) // 24 hours
        .build()?;
    
    // Deploy the contract
    let deployment = orchestrator.deploy_contract(escrow).await?;
    println!("Contract deployed: {}", deployment.txid());
    
    Ok(())
}
```

### 🌉 CCI-SAT - Cross-Chain Transfers

Set up an atomic swap:

```rust
use cci_sat::prelude::*;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize CCI-SAT
    let config = CCISATConfig::from_env()?;
    let swap_engine = AtomicSwapEngine::new(config).await?;
    
    // Create Bitcoin to Ethereum swap
    let swap = AtomicSwap::builder()
        .from_chain(Chain::Bitcoin)
        .to_chain(Chain::Ethereum)
        .from_amount(100_000) // 0.001 BTC
        .to_amount(parse_units("0.05", 18)?) // 0.05 ETH
        .counterparty(counterparty_pubkey)
        .timeout_blocks(144)
        .build()?;
    
    // Initiate the swap
    let swap_id = swap_engine.initiate_swap(swap).await?;
    println!("Atomic swap initiated: {}", swap_id);
    
    Ok(())
}
```

### 🤖 AICRM-SDK - Compliance

Implement transaction monitoring:

```rust
use aicrm_sdk::prelude::*;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize AICRM
    let config = AICRMConfig::from_env()?;
    let analyzer = RiskAnalyzer::new(config).await?;
    
    // Analyze a transaction
    let transaction = get_transaction_from_mempool().await?;
    let assessment = analyzer.analyze_transaction(&transaction).await?;
    
    match assessment.risk_level() {
        RiskLevel::Low => println!("✅ Transaction approved"),
        RiskLevel::Medium => println!("⚠️ Manual review required"),
        RiskLevel::High => println!("🚨 Transaction flagged"),
        RiskLevel::Critical => println!("❌ Transaction blocked"),
    }
    
    Ok(())
}
```

### ⚡ IMO-EO - Mining Optimization

Optimize mining operations:

```rust
use imo_eo::prelude::*;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize IMO-EO
    let config = IMOEOConfig::from_env()?;
    let optimizer = MiningOptimizer::new(config).await?;
    
    // Get current mining stats
    let stats = optimizer.get_mining_stats().await?;
    println!("Hashrate: {} TH/s", stats.hashrate_ths());
    println!("Power: {} kW", stats.power_consumption_kw());
    println!("Efficiency: {} J/TH", stats.efficiency_j_th());
    
    // Start optimization
    optimizer.start_optimization().await?;
    println!("Mining optimization started");
    
    Ok(())
}
```

## 🔍 Verification & Testing

### 1. Verify Installation

```bash
# Check all libraries compile
cargo check --workspace

# Run basic tests
cargo test --lib --workspace

# Verify documentation builds
cargo doc --workspace --no-deps
```

### 2. Integration Tests

```bash
# Run integration tests (requires Bitcoin node)
cargo test --test integration --workspace

# Run with specific features
cargo test --workspace --features "testnet,mock"

# Run benchmarks
cargo bench --workspace
```

### 3. Health Check Script

Create a health check script:

```bash
#!/bin/bash
# health-check.sh

echo "🔍 Bitcoin Enterprise Suite Health Check"
echo "========================================"

# Check Rust version
echo "📦 Checking Rust version..."
rustc --version

# Check Bitcoin node connectivity
echo "₿ Checking Bitcoin node..."
bitcoin-cli -testnet getblockchaininfo > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Bitcoin node is running"
else
    echo "❌ Bitcoin node is not accessible"
fi

# Test library compilation
echo "🔧 Testing library compilation..."
cargo check --workspace --quiet
if [ $? -eq 0 ]; then
    echo "✅ All libraries compile successfully"
else
    echo "❌ Compilation errors detected"
fi

# Run quick tests
echo "🧪 Running quick tests..."
cargo test --lib --workspace --quiet
if [ $? -eq 0 ]; then
    echo "✅ All tests pass"
else
    echo "❌ Some tests failed"
fi

echo "✅ Health check complete!"
```

Make it executable:
```bash
chmod +x health-check.sh
./health-check.sh
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Bitcoin Node Connection Issues

```bash
# Check if Bitcoin node is running
bitcoin-cli getblockchaininfo

# Check RPC credentials
curl --user bitcoinrpc:changeme123 \
  --data-binary '{"jsonrpc":"1.0","id":"test","method":"getblockchaininfo","params":[]}' \
  -H 'content-type: text/plain;' \
  http://localhost:8332/
```

#### 2. Compilation Errors

```bash
# Update Rust toolchain
rustup update

# Clean and rebuild
cargo clean
cargo build --workspace

# Check for missing system dependencies
sudo apt-get install build-essential pkg-config libssl-dev
```

#### 3. Network Issues

```bash
# For testnet development
export BITCOIN_NETWORK=testnet
export BITCOIN_RPC_URL=http://localhost:18332

# For regtest (local testing)
export BITCOIN_NETWORK=regtest
export BITCOIN_RPC_URL=http://localhost:18443
```

### Getting Help

If you encounter issues:

1. **Check the logs**: Enable debug logging with `RUST_LOG=debug`
2. **Review documentation**: Each library has comprehensive documentation
3. **Search issues**: Check [GitHub Issues](https://github.com/bitcoin-enterprise-suite/bitcoin-enterprise-suite/issues)
4. **Community support**: Join our [Discord](https://discord.gg/bitcoin-enterprise-suite)
5. **Enterprise support**: Contact [enterprise@bitcoin-enterprise-suite.org](mailto:enterprise@bitcoin-enterprise-suite.org)

## 🎯 Next Steps

Now that you have the Bitcoin Enterprise Suite set up:

1. **Explore Examples**: Check out the [examples directory](../../examples/) for practical use cases
2. **Read Architecture Docs**: Understand the [system architecture](../architecture/overview.md)
3. **Security Guidelines**: Review [security best practices](../security/SECURITY.md)
4. **Join Community**: Participate in [GitHub Discussions](https://github.com/bitcoin-enterprise-suite/bitcoin-enterprise-suite/discussions)
5. **Contribute**: Read our [Contributing Guide](../../CONTRIBUTING.md)

## 🚀 Production Deployment

For production deployments, see our:

- [Deployment Guide](../deployment/production.md)
- [Security Checklist](../security/production-checklist.md)
- [Monitoring Setup](../operations/monitoring.md)
- [Performance Tuning](../performance/optimization.md)

---

<div align="center">
  <strong>Welcome to the future of enterprise Bitcoin infrastructure! 🚀</strong>
</div>