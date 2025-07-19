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
pub mod error;
pub mod risk;
pub mod compliance;
pub mod monitoring;
pub mod ml;
pub mod reporting;
pub mod analytics;

// Prelude for convenience
pub mod prelude {
    //! Common imports and types for AICRM-SDK users
    
    pub use crate::error::*;
    pub use crate::risk::*;
    pub use crate::compliance::*;
    pub use crate::monitoring::*;
    pub use crate::analytics::*;
}

// Main public API exports
pub use error::{Error, Result};
pub use risk::{RiskAnalyzer, RiskScore, RiskModel};
pub use compliance::{ComplianceEngine, AmlCheck, KycVerification};
pub use monitoring::{TransactionMonitor, AlertManager};
pub use analytics::{Analytics, Report, Dashboard};

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
    fn test_library_version() {
        assert!(!VERSION.is_empty());
    }

    #[tokio::test]
    async fn test_init() {
        assert!(init().await.is_ok());
    }
}