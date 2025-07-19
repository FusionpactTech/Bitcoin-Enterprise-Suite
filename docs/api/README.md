# 🔧 API References - Bitcoin Enterprise Suite

*Powered by [Fusionpact Technologies Inc.](https://fusionpact.com)*

Welcome to the comprehensive API documentation for all Bitcoin Enterprise Suite libraries. This reference provides detailed information about classes, methods, types, and usage patterns for each library.

## 📚 Library API References

### 🔐 BiSCOL - Bitcoin-Native Smart Contract Orchestration Layer

**Latest Version:** `0.1.0` | **[Crate Documentation](https://docs.rs/biscol)**

#### Core Types

##### `SmartContract`
The main contract orchestration interface.

```rust
pub struct SmartContract;

impl SmartContract {
    /// Create a new smart contract instance
    pub fn new() -> Self;
    
    /// Create a contract builder for advanced configuration
    pub fn builder() -> ContractBuilder;
    
    /// Execute the contract with given context
    pub async fn execute(&self, context: &ExecutionContext) -> Result<ExecutionResult>;
}
```

##### `ExecutionContext`
Context and environment for contract execution.

```rust
pub struct ExecutionContext;
// Implementation details in full API docs
```

##### `ExecutionResult`
Result and state changes from contract execution.

```rust
pub struct ExecutionResult;
// Implementation details in full API docs
```

#### Example Usage

```rust
use biscol::{SmartContract, ExecutionContext};

#[tokio::main]
async fn main() -> Result<(), biscol::Error> {
    let contract = SmartContract::new();
    // Configure and execute contract
    Ok(())
}
```

---

### 🌉 CCI-SAT - Cross-Chain Interoperability & Secure Asset Transfer Suite

**Latest Version:** `0.1.0` | **[Crate Documentation](https://docs.rs/cci-sat)**

#### Core Types

##### `AtomicSwap`
Cross-chain atomic swap operations.

```rust
pub struct AtomicSwap;

impl AtomicSwap {
    /// Create a new atomic swap instance
    pub fn new() -> Self;
    
    /// Create a swap builder for configuration
    pub fn builder() -> SwapBuilder;
    
    /// Execute the atomic swap
    pub async fn execute(&self) -> Result<SwapExecution>;
}
```

##### `LightningChannel`
Lightning Network channel management.

```rust
pub struct LightningChannel;
// Implementation details in full API docs
```

##### `Bridge`
Cross-chain bridge operations.

```rust
pub struct Bridge;
// Implementation details in full API docs
```

#### Example Usage

```rust
use cci_sat::{AtomicSwap, LightningChannel};

#[tokio::main]
async fn main() -> Result<(), cci_sat::Error> {
    let swap = AtomicSwap::new();
    // Configure and execute swap
    Ok(())
}
```

---

### 🛡️ AICRM-SDK - AI-Driven Compliance & Risk Management Platform SDK

**Latest Version:** `0.1.0` | **[Crate Documentation](https://docs.rs/aicrm-sdk)**

#### Core Types

##### `RiskAnalyzer`
AI-powered transaction risk analysis.

```rust
pub struct RiskAnalyzer;

impl RiskAnalyzer {
    /// Create a new risk analyzer instance
    pub fn new() -> Self;
    
    /// Create an analyzer builder for configuration
    pub fn builder() -> RiskAnalyzerBuilder;
    
    /// Analyze transaction risk
    pub async fn analyze_transaction(&self, tx: &bitcoin::Transaction) -> Result<RiskScore>;
}
```

##### `ComplianceEngine`
Regulatory compliance checking and reporting.

```rust
pub struct ComplianceEngine;
// Implementation details in full API docs
```

##### `TransactionMonitor`
Real-time transaction monitoring and alerting.

```rust
pub struct TransactionMonitor;
// Implementation details in full API docs
```

##### `RiskScore`
Risk assessment result with confidence metrics.

```rust
pub struct RiskScore;
// Implementation details in full API docs
```

#### Example Usage

```rust
use aicrm_sdk::{RiskAnalyzer, ComplianceEngine};

#[tokio::main]
async fn main() -> Result<(), aicrm_sdk::Error> {
    let analyzer = RiskAnalyzer::new();
    // Analyze transactions and assess risk
    Ok(())
}
```

---

### ⚡ IMO-EO - Intelligent Mining Operations & Energy Optimization Framework

**Latest Version:** `0.1.0` | **[Crate Documentation](https://docs.rs/imo-eo)**

#### Core Types

##### `MiningOptimizer`
Intelligent mining operation optimization.

```rust
pub struct MiningOptimizer;

impl MiningOptimizer {
    /// Create a new mining optimizer instance
    pub fn new() -> Self;
    
    /// Create an optimizer builder for configuration
    pub fn builder() -> MiningOptimizerBuilder;
    
    /// Optimize mining operations
    pub async fn optimize(&self) -> Result<Recommendations>;
}
```

##### `EnergyMonitor`
Real-time energy consumption monitoring.

```rust
pub struct EnergyMonitor;
// Implementation details in full API docs
```

##### `HardwareManager`
Mining hardware management and coordination.

```rust
pub struct HardwareManager;
// Implementation details in full API docs
```

##### `Recommendations`
Optimization recommendations and strategies.

```rust
pub struct Recommendations;
// Implementation details in full API docs
```

#### Example Usage

```rust
use imo_eo::{MiningOptimizer, EnergyMonitor};

#[tokio::main]
async fn main() -> Result<(), imo_eo::Error> {
    let optimizer = MiningOptimizer::new();
    // Optimize mining operations
    Ok(())
}
```

## 🔄 Common Patterns

### Error Handling

All libraries follow consistent error handling patterns:

```rust
use biscol::{Result, Error};

fn handle_errors() -> Result<()> {
    match some_operation() {
        Ok(result) => {
            // Handle success
            Ok(())
        },
        Err(Error::Bitcoin(msg)) => {
            // Handle Bitcoin-related errors
            eprintln!("Bitcoin error: {}", msg);
            Err(Error::Bitcoin(msg))
        },
        Err(e) => {
            // Handle other errors
            eprintln!("Error: {}", e);
            Err(e)
        }
    }
}
```

### Async Operations

Most operations are asynchronous and return Futures:

```rust
use tokio;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Multiple async operations
    let results = tokio::try_join!(
        operation_one(),
        operation_two(),
        operation_three()
    )?;
    
    Ok(())
}
```

### Builder Patterns

All libraries support builder patterns for complex configuration:

```rust
use biscol::SmartContract;

let contract = SmartContract::builder()
    .with_timeout(Duration::from_secs(30))
    .with_gas_limit(1_000_000)
    .enable_debugging()
    .build()?;
```

## 🔍 Type Reference

### Common Types

Types shared across libraries:

```rust
// Bitcoin types (re-exported from bitcoin crate)
pub use bitcoin::{Address, Network, Transaction, TxOut};

// Cryptographic types
pub use secp256k1::{PublicKey, SecretKey};
pub use secp256k1::ecdsa::Signature;

// Async types
pub use tokio::{spawn, time::{Duration, Instant}};

// Serialization
pub use serde::{Serialize, Deserialize};
```

### Error Types

Each library defines its own error type implementing standard traits:

```rust
#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("Bitcoin error: {0}")]
    Bitcoin(String),
    
    #[error("Network error: {0}")]
    Network(String),
    
    #[error("Validation error: {0}")]
    Validation(String),
    
    #[error("Configuration error: {0}")]
    Configuration(String),
}

pub type Result<T> = std::result::Result<T, Error>;
```

## 🧪 Testing Utilities

### Test Helpers

Each library provides testing utilities:

```rust
#[cfg(test)]
mod tests {
    use biscol::test_utils::*;
    
    #[tokio::test]
    async fn test_contract_execution() {
        let mock_context = create_mock_context();
        let contract = create_test_contract();
        
        let result = contract.execute(&mock_context).await;
        assert!(result.is_ok());
    }
}
```

### Integration Testing

Cross-library integration patterns:

```rust
use biscol::SmartContract;
use cci_sat::AtomicSwap;
use aicrm_sdk::RiskAnalyzer;

#[tokio::test]
async fn test_full_integration() {
    let analyzer = RiskAnalyzer::new();
    let contract = SmartContract::new();
    let swap = AtomicSwap::new();
    
    // Test integration between components
    // ... implementation
}
```

## 📖 Additional Resources

### Auto-Generated Documentation

- **[docs.rs/biscol](https://docs.rs/biscol)** - Complete BiSCOL API documentation
- **[docs.rs/cci-sat](https://docs.rs/cci-sat)** - Complete CCI-SAT API documentation
- **[docs.rs/aicrm-sdk](https://docs.rs/aicrm-sdk)** - Complete AICRM-SDK API documentation
- **[docs.rs/imo-eo](https://docs.rs/imo-eo)** - Complete IMO-EO API documentation

### Code Examples

- **[Basic Examples](../../examples/)** - Simple usage examples
- **[Advanced Examples](../../examples/advanced/)** - Complex integration patterns
- **[Benchmarks](../../benches/)** - Performance benchmarks and comparisons

### Community Resources

- **[GitHub Discussions](https://github.com/FusionpactTech/Bitcoin-Enterprise-Suite/discussions)** - API questions and community support
- **[Discord](https://discord.gg/ZK5n8A8B)** - Real-time developer chat
- **[Contributing Guide](../../CONTRIBUTING.md)** - How to contribute to API development

## 🛠️ Development Tools

### Generate Documentation Locally

```bash
# Generate and open documentation for all libraries
cargo doc --workspace --open

# Generate documentation for specific library
cargo doc -p biscol --open

# Include private items in documentation
cargo doc --workspace --document-private-items
```

### API Stability

- **🟢 Stable**: Public APIs marked as stable
- **🟡 Experimental**: APIs that may change in future versions
- **🔴 Internal**: Internal APIs not intended for public use

---

<div align="center">
  <strong>Comprehensive API documentation for enterprise Bitcoin development</strong>
  <br>
  <sub>Powered by Fusionpact Technologies Inc.</sub>
</div>