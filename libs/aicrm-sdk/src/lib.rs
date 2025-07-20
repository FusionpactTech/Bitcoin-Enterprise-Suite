//! # AICRM-SDK - AI-Driven Compliance & Risk Management Platform SDK
//!
//! AICRM-SDK provides intelligent compliance automation for Bitcoin operations.
//! This library enables real-time transaction monitoring, regulatory compliance
//! automation, and AI-powered risk assessment for enterprise Bitcoin applications.
//!
//! ## Features
//!
//! - **Real-Time Monitoring**: Continuous transaction surveillance
//! - **Risk Scoring**: ML-powered risk assessment algorithms
//! - **Compliance Automation**: AML/KYC workflow automation
//! - **Audit Trails**: Comprehensive reporting and documentation
//!
//! ## Quick Start
//!
//! ```rust,no_run
//! use aicrm_sdk::{RiskAnalyzer, ComplianceEngine, TransactionMonitor};
//!
//! # async fn example() -> Result<(), aicrm_sdk::Error> {
//! // Create a risk analyzer
//! let analyzer = RiskAnalyzer::new();
//!
//! // Note: In real usage, you would have an actual Bitcoin transaction
//! // let risk_score = analyzer.analyze_transaction(&tx).await?;
//! # Ok(())
//! # }
//! ```

#![cfg_attr(not(feature = "std"), no_std)]
#![cfg_attr(docsrs, feature(doc_auto_cfg))]
#![deny(missing_docs)]
#![warn(rust_2018_idioms)]

// Re-export commonly used types
pub use bitcoin::{Address, Network, Transaction, TxOut};

// Core modules
pub mod analytics;
pub mod compliance;
pub mod error;
pub mod ml;
pub mod monitoring;
pub mod reporting;
pub mod risk;

// Prelude for convenience
pub mod prelude {
    //! Common imports and types for AICRM-SDK users

    pub use crate::analytics::*;
    pub use crate::compliance::*;
    pub use crate::error::*;
    pub use crate::monitoring::*;
    pub use crate::risk::*;
}

// Main public API exports
pub use analytics::{Analytics, Dashboard, Report};
pub use compliance::{AmlCheck, ComplianceEngine, KycVerification};
pub use error::{Error, Result};
pub use monitoring::{AlertManager, TransactionMonitor};
pub use risk::{RiskAnalyzer, RiskModel, RiskScore};

/// Library version
pub const VERSION: &str = env!("CARGO_PKG_VERSION");

/// Initialize AICRM-SDK with default configuration
pub async fn init() -> Result<()> {
    tracing::info!("Initializing AICRM-SDK v{}", VERSION);
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

    #[tokio::test]
    async fn test_init() {
        assert!(init().await.is_ok());
    }
}
