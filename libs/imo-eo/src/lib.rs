//! # IMO-EO - Intelligent Mining Operations & Energy Optimization Framework
//!
//! IMO-EO provides AI-powered mining efficiency and sustainable energy management.
//! This library enables dynamic mining pool optimization, energy consumption analytics,
//! predictive maintenance, and carbon footprint tracking for Bitcoin mining operations.
//!
//! ## Features
//!
//! - **Pool Optimization**: Dynamic mining pool selection and optimization
//! - **Energy Analytics**: Comprehensive energy consumption monitoring
//! - **Predictive Maintenance**: AI-powered hardware health monitoring
//! - **Carbon Tracking**: Environmental impact assessment and offsetting
//!
//! ## Quick Start
//!
//! ```rust,no_run
//! use imo_eo::{MiningOptimizer, EnergyMonitor, HardwareManager};
//!
//! # async fn example() -> Result<(), imo_eo::Error> {
//! // Create a mining optimizer
//! let optimizer = MiningOptimizer::new();
//!
//! // Note: In real usage, you would configure with actual efficiency targets and costs
//! // let recommendations = optimizer.optimize().await?;
//! # Ok(())
//! # }
//! ```

#![cfg_attr(not(feature = "std"), no_std)]
#![cfg_attr(docsrs, feature(doc_auto_cfg))]
#![deny(missing_docs)]
#![warn(rust_2018_idioms)]

// Re-export commonly used types
pub use bitcoin::{Address, Network, Transaction, BlockHash};

// Core modules
pub mod error;
pub mod mining;
pub mod energy;
pub mod hardware;
pub mod optimization;
pub mod analytics;
pub mod carbon;

// Prelude for convenience
pub mod prelude {
    //! Common imports and types for IMO-EO users
    
    pub use crate::error::*;
    pub use crate::mining::*;
    pub use crate::energy::*;
    pub use crate::hardware::*;
    pub use crate::optimization::*;
    pub use crate::analytics::*;
}

// Main public API exports
pub use error::{Error, Result};
pub use mining::{MiningOptimizer, PoolManager, MiningStrategy};
pub use energy::{EnergyMonitor, PowerManager, EfficiencyTracker};
pub use hardware::{HardwareManager, MaintenanceScheduler, HealthMonitor};
pub use optimization::{Optimizer, OptimizationStrategy, Recommendations};
pub use carbon::{CarbonTracker, EmissionsCalculator, OffsetManager};

/// Library version
pub const VERSION: &str = env!("CARGO_PKG_VERSION");

/// Initialize IMO-EO with default configuration
pub async fn init() -> Result<()> {
    tracing::info!("Initializing IMO-EO v{}", VERSION);
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