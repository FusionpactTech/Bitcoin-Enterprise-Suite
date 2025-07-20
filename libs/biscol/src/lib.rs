//! # BiSCOL - Bitcoin-Native Smart Contract Orchestration Layer
//!
//! BiSCOL provides confidential smart contracts on Bitcoin with enterprise-grade privacy.
//! This library enables zero-knowledge proof integration, multi-signature orchestration,
//! and Taproot-optimized script execution for Bitcoin-native smart contracts.
//!
//! ## Features
//!
//! - **Zero-Knowledge Proofs**: Privacy-preserving transaction validation
//! - **Multi-Signature Orchestration**: Advanced multi-sig with time-locked contracts
//! - **Taproot Integration**: Optimized script execution using Bitcoin's latest features
//! - **Enterprise Compliance**: Built-in compliance reporting and audit trails
//!
//! ## Quick Start
//!
//! ```rust,no_run
//! use biscol::{Script, ExecutionContext, SmartContract};
//!
//! # async fn example() -> Result<(), biscol::Error> {
//! // Create a new smart contract
//! let contract = SmartContract::new();
//!
//! // Note: In real usage, you would configure with actual scripts and contexts
//! // let result = contract.execute(&context).await?;
//! # Ok(())
//! # }
//! ```

#![cfg_attr(not(feature = "std"), no_std)]
#![cfg_attr(docsrs, feature(doc_auto_cfg))]
#![deny(missing_docs)]
#![warn(rust_2018_idioms)]

// Re-export commonly used types from bitcoin crate
pub use bitcoin::{Address, Network, Transaction, TxOut};
pub use secp256k1::ecdsa::Signature;
pub use secp256k1::{PublicKey, SecretKey};

// Core modules
pub mod compliance;
pub mod contract;
pub mod error;
pub mod multisig;
pub mod script;
pub mod taproot;
pub mod zk;

// Prelude for convenience
pub mod prelude {
    //! Common imports and types for BiSCOL users

    pub use crate::contract::*;
    pub use crate::error::*;
    pub use crate::multisig::*;
    pub use crate::script::*;
    pub use crate::taproot::*;
}

// Main public API exports
pub use contract::{ContractBuilder, ContractExecution, SmartContract};
pub use error::{Error, Result};
pub use multisig::{MultiSig, MultiSigBuilder, Threshold};
pub use script::{ExecutionContext, ExecutionResult, Script, ScriptBuilder};
pub use taproot::{TaprootBuilder, TaprootScript};

/// Library version
pub const VERSION: &str = env!("CARGO_PKG_VERSION");

/// Initialize BiSCOL with default configuration
pub fn init() -> Result<()> {
    tracing::info!("Initializing BiSCOL v{}", VERSION);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[allow(clippy::len_zero)]
    fn test_library_version() {
        assert!(VERSION.len() > 0);
    }

    #[test]
    fn test_init() {
        assert!(init().is_ok());
    }
}
