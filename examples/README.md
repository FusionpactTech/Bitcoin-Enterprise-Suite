# 💡 Bitcoin Enterprise Suite Examples

This directory contains practical, runnable examples demonstrating how to use the Bitcoin Enterprise Suite libraries in real-world scenarios.

## 📚 Quick Navigation

- [🔐 BiSCOL Examples](#-biscol-examples) - Smart Contract Orchestration
- [🌉 CCI-SAT Examples](#-cci-sat-examples) - Cross-Chain Interoperability  
- [🤖 AICRM-SDK Examples](#-aicrm-sdk-examples) - AI-Driven Compliance
- [⚡ IMO-EO Examples](#-imo-eo-examples) - Mining Operations
- [🔗 Integration Examples](#-integration-examples) - Multi-library workflows

## 🚀 Getting Started

### Prerequisites

```bash
# Ensure you have the Bitcoin Enterprise Suite installed
cargo --version  # Rust 1.70+
git --version

# Clone the repository if you haven't already
git clone https://github.com/bitcoin-enterprise-suite/bitcoin-enterprise-suite.git
cd bitcoin-enterprise-suite/examples
```

### Running Examples

Each example can be run independently:

```bash
# Run a specific example
cargo run --example basic_smart_contract

# Run with specific features
cargo run --example atomic_swap --features "testnet"

# Run in release mode for performance testing
cargo run --release --example mining_optimization
```

## 🔐 BiSCOL Examples

### [Basic Smart Contract](./biscol/basic_contract.rs)
Create and deploy a simple Bitcoin smart contract using zero-knowledge proofs.

```bash
cargo run --example basic_smart_contract
```

**What it demonstrates:**
- Contract creation and deployment
- Zero-knowledge proof generation
- Transaction building and broadcasting

### [Escrow Contract](./biscol/escrow_contract.rs)
Multi-party escrow contract with time-locked release conditions.

```bash
cargo run --example escrow_contract
```

**Features:**
- Multi-signature coordination
- Time-locked contracts
- Dispute resolution mechanisms

### [Privacy-Preserving Payments](./biscol/private_payments.rs)
Confidential transactions using bulletproofs for amount hiding.

```bash
cargo run --example private_payments
```

**Highlights:**
- Amount blinding with commitments
- Range proofs for validation
- Privacy-preserving audit trails

### [Taproot Optimization](./biscol/taproot_scripts.rs)
Advanced Taproot script tree construction and optimization.

```bash
cargo run --example taproot_scripts
```

**Demonstrates:**
- Script tree construction
- Path optimization for gas efficiency
- MuSig2 signature aggregation

## 🌉 CCI-SAT Examples

### [Bitcoin-Ethereum Atomic Swap](./cci-sat/btc_eth_swap.rs)
Cross-chain atomic swap between Bitcoin and Ethereum.

```bash
cargo run --example btc_eth_swap
```

**Features:**
- Hash Time-Locked Contracts (HTLC)
- Cross-chain validation
- Automatic refund mechanisms

### [Lightning Network Integration](./cci-sat/lightning_payments.rs)
Lightning Network payments and channel management.

```bash
cargo run --example lightning_payments
```

**Capabilities:**
- Channel opening and closing
- Payment routing optimization
- Submarine swaps (on-chain ↔ Lightning)

### [Multi-Chain Portfolio](./cci-sat/multi_chain_wallet.rs)
Unified wallet interface for multiple blockchains.

```bash
cargo run --example multi_chain_wallet
```

**Includes:**
- Unified balance tracking
- Cross-chain transaction history
- Multi-chain fee optimization

### [Decentralized Bridge](./cci-sat/bridge_protocol.rs)
Decentralized bridge with fraud proofs and validator network.

```bash
cargo run --example bridge_protocol
```

**Features:**
- Fraud proof generation and verification
- Validator consensus mechanisms
- Emergency pause functionality

## 🤖 AICRM-SDK Examples

### [Transaction Risk Analysis](./aicrm-sdk/risk_analysis.rs)
Real-time transaction risk assessment using AI models.

```bash
cargo run --example risk_analysis
```

**Demonstrates:**
- ML-based risk scoring
- Pattern recognition for suspicious activities
- Real-time monitoring and alerting

### [AML/KYC Automation](./aicrm-sdk/kyc_workflow.rs)
Automated Know Your Customer (KYC) verification workflow.

```bash
cargo run --example kyc_workflow
```

**Features:**
- Document verification
- Identity validation
- Sanctions screening
- Compliance reporting

### [Suspicious Activity Detection](./aicrm-sdk/suspicious_activity.rs)
Advanced pattern detection for money laundering activities.

```bash
cargo run --example suspicious_activity
```

**Capabilities:**
- Graph analysis of transaction patterns
- Behavioral anomaly detection
- Automated Suspicious Activity Report (SAR) generation

### [Regulatory Compliance](./aicrm-sdk/compliance_reporting.rs)
Automated compliance reporting for multiple jurisdictions.

```bash
cargo run --example compliance_reporting
```

**Includes:**
- Multi-jurisdiction support
- Automated report generation
- Regulatory change tracking

## ⚡ IMO-EO Examples

### [Mining Optimization](./imo-eo/mining_optimizer.rs)
AI-powered mining operation optimization.

```bash
cargo run --example mining_optimizer
```

**Features:**
- Dynamic pool switching
- Profitability optimization
- Hardware efficiency monitoring

### [Energy Management](./imo-eo/energy_optimization.rs)
Renewable energy integration and optimization.

```bash
cargo run --example energy_optimization
```

**Capabilities:**
- Solar/wind energy integration
- Battery storage optimization
- Grid energy cost minimization

### [Predictive Maintenance](./imo-eo/predictive_maintenance.rs)
AI-driven hardware failure prediction and prevention.

```bash
cargo run --example predictive_maintenance
```

**Demonstrates:**
- Sensor data analysis
- Failure prediction models
- Maintenance scheduling optimization

### [Carbon Footprint Tracking](./imo-eo/carbon_tracking.rs)
Comprehensive carbon footprint monitoring and offset management.

```bash
cargo run --example carbon_tracking
```

**Features:**
- Real-time carbon emissions tracking
- Renewable energy impact calculation
- Automated carbon offset purchasing

## 🔗 Integration Examples

### [Enterprise Bitcoin Platform](./integration/enterprise_platform.rs)
Complete enterprise Bitcoin platform integrating all libraries.

```bash
cargo run --example enterprise_platform
```

**Full-stack example including:**
- Smart contract management
- Cross-chain operations
- Compliance monitoring
- Mining optimization

### [DeFi Protocol](./integration/defi_protocol.rs)
Decentralized finance protocol with Bitcoin integration.

```bash
cargo run --example defi_protocol
```

**Features:**
- Bitcoin-backed lending
- Cross-chain yield farming
- Automated compliance checking
- Risk management integration

### [Payment Gateway](./integration/payment_gateway.rs)
Enterprise payment gateway with compliance and optimization.

```bash
cargo run --example payment_gateway
```

**Capabilities:**
- Multi-chain payment processing
- Real-time compliance checking
- Fraud detection and prevention
- Performance optimization

### [REST API Server](./integration/api_server.rs)
Production-ready REST API server using all libraries.

```bash
cargo run --example api_server
```

**Includes:**
- RESTful API endpoints
- WebSocket real-time updates
- Authentication and authorization
- Comprehensive monitoring

## 🧪 Testing Examples

### Development Environment

```bash
# Set up test environment
export BITCOIN_NETWORK=regtest
export RUST_LOG=debug

# Run example with verbose logging
RUST_LOG=trace cargo run --example basic_smart_contract
```

### Integration Testing

```bash
# Run all examples as integration tests
./scripts/test_examples.sh

# Test specific category
./scripts/test_examples.sh biscol
./scripts/test_examples.sh cci-sat
./scripts/test_examples.sh aicrm-sdk
./scripts/test_examples.sh imo-eo
```

## 📝 Example Template

Use this template to create new examples:

```rust
//! Example: [Your Example Name]
//! 
//! Description: Brief description of what this example demonstrates
//! 
//! Prerequisites:
//! - Bitcoin node running (testnet recommended)
//! - Environment variables configured
//! 
//! Usage:
//! ```bash
//! cargo run --example your_example_name
//! ```

use std::error::Error;
use tokio;

// Import required libraries
use bitcoin_enterprise_suite::prelude::*;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    // Initialize logging
    env_logger::init();
    
    println!("🟠 Bitcoin Enterprise Suite Example: [Your Example Name]");
    
    // Your example code here
    
    println!("✅ Example completed successfully!");
    
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[tokio::test]
    async fn test_example() {
        // Test your example logic
        assert!(true);
    }
}
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file for consistent configuration across examples:

```bash
# Bitcoin Network Configuration
BITCOIN_NETWORK=testnet
BITCOIN_RPC_URL=http://localhost:18332
BITCOIN_RPC_USER=bitcoinrpc
BITCOIN_RPC_PASSWORD=changeme123

# Logging Configuration
RUST_LOG=info
RUST_BACKTRACE=1

# Feature Flags
ENABLE_AI_MODELS=true
ENABLE_REAL_TIME_MONITORING=true
ENABLE_CROSS_CHAIN=true

# Performance Settings
WORKER_THREADS=4
CACHE_SIZE=1000
BATCH_SIZE=100
```

### Test Configuration

```toml
# examples/Cargo.toml
[package]
name = "bitcoin-enterprise-examples"
version = "0.1.0"
edition = "2021"

[dependencies]
# Bitcoin Enterprise Suite libraries
biscol = { path = "../libs/biscol" }
cci-sat = { path = "../libs/cci-sat" }
aicrm-sdk = { path = "../libs/aicrm-sdk" }
imo-eo = { path = "../libs/imo-eo" }

# Common dependencies
tokio = { version = "1.0", features = ["full"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
env_logger = "0.10"
dotenv = "0.15"

# Example-specific dependencies
reqwest = { version = "0.11", features = ["json"] }
uuid = { version = "1.0", features = ["v4"] }

[[example]]
name = "basic_smart_contract"
path = "biscol/basic_contract.rs"

[[example]]
name = "atomic_swap"
path = "cci-sat/btc_eth_swap.rs"

# Add more examples as needed...
```

## 🚀 Contributing Examples

We welcome community contributions! To add a new example:

1. **Choose a category** - Select the appropriate library directory
2. **Follow the template** - Use the example template above
3. **Add documentation** - Include clear comments and usage instructions
4. **Test thoroughly** - Ensure your example works in different environments
5. **Update this README** - Add your example to the appropriate section

### Example Guidelines

- **Self-contained**: Each example should be runnable independently
- **Well-documented**: Include clear comments explaining each step
- **Error handling**: Demonstrate proper error handling patterns
- **Realistic**: Use realistic data and scenarios when possible
- **Tested**: Include unit tests where appropriate

## 📚 Additional Resources

- **[📖 Documentation](../docs/README.md)** - Complete documentation
- **[🏗️ Architecture](../docs/architecture/overview.md)** - System architecture
- **[🛡️ Security](../docs/security/SECURITY.md)** - Security best practices
- **[🤝 Contributing](../CONTRIBUTING.md)** - How to contribute
- **[💬 Discord](https://discord.gg/bitcoin-enterprise-suite)** - Community support

---

<div align="center">
  <strong>🚀 Start building the future of Bitcoin infrastructure!</strong>
  <br>
  <sub>Examples are the best way to learn - dive in and start experimenting!</sub>
</div>