//! # CCI-SAT - Cross-Chain Interoperability & Secure Asset Transfer Suite
//!
//! CCI-SAT enables seamless, secure asset transfers across blockchain networks.
//! This library provides atomic swaps, Lightning Network integration, decentralized
//! bridge protocols, and multi-chain wallet abstraction.
//!
//! ## Features
//!
//! - **Atomic Swaps**: Trustless cross-chain asset exchanges
//! - **Lightning Network**: Instant Bitcoin settlements
//! - **Bridge Protocols**: Decentralized bridges with fraud proofs
//! - **Multi-Chain Wallets**: Unified wallet abstraction layer
//!
//! ## Quick Start
//!
//! ```rust,no_run
//! use cci_sat::{AtomicSwap, LightningChannel, Bridge};
//!
//! # async fn example() -> Result<(), cci_sat::Error> {
//! // Create an atomic swap
//! let swap = AtomicSwap::new();
//!
//! // Note: In real usage, you would configure with actual amounts and parameters
//! // let result = swap.execute().await?;
//! # Ok(())
//! # }
//! ```

#![cfg_attr(not(feature = "std"), no_std)]
#![cfg_attr(docsrs, feature(doc_auto_cfg))]
#![deny(missing_docs)]
#![warn(rust_2018_idioms)]

// Re-export commonly used types
pub use bitcoin::{Address, Network, Transaction, TxOut};
// pub use lightning::ln::channelmanager::ChannelManager;  // Temporarily disabled

// Core modules
pub mod error;
pub mod atomic_swap;
pub mod lightning;
pub mod bridge;
pub mod wallet;
pub mod protocols;
pub mod monitoring;

// Prelude for convenience
pub mod prelude {
    //! Common imports and types for CCI-SAT users
    
    pub use crate::error::*;
    pub use crate::atomic_swap::*;
    pub use crate::lightning::*;
    pub use crate::bridge::*;
    pub use crate::wallet::*;
}

// Main public API exports
pub use error::{Error, Result};
pub use atomic_swap::{AtomicSwap, SwapBuilder, SwapExecution};
pub use lightning::{LightningChannel, ChannelBuilder};
pub use bridge::{Bridge, BridgeProtocol, FraudProof};
pub use wallet::{MultiChainWallet, WalletBuilder};

/// Library version
pub const VERSION: &str = env!("CARGO_PKG_VERSION");

/// Initialize CCI-SAT with default configuration
pub async fn init() -> Result<()> {
    tracing::info!("Initializing CCI-SAT v{}", VERSION);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_library_version() {
        assert!(!VERSION.is_empty());
    }

    #[tokio::test]
    async fn test_init() {
        assert!(init().await.is_ok());
    }
}