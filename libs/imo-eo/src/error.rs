//! Error types for IMO-EO

use thiserror::Error;

/// Result type alias for IMO-EO operations
pub type Result<T> = std::result::Result<T, Error>;

/// Main error type for IMO-EO operations
#[derive(Error, Debug)]
pub enum Error {
    /// Mining optimization errors
    #[error("Mining optimization failed: {0}")]
    MiningOptimization(String),
    
    /// Energy monitoring errors
    #[error("Energy monitoring error: {0}")]
    EnergyMonitoring(String),
    
    /// Hardware management errors
    #[error("Hardware management error: {0}")]
    Hardware(String),
    
    /// Pool management errors
    #[error("Pool management error: {0}")]
    PoolManagement(String),
    
    /// Analytics errors
    #[error("Analytics error: {0}")]
    Analytics(String),
    
    /// Carbon tracking errors
    #[error("Carbon tracking error: {0}")]
    CarbonTracking(String),
    
    /// Configuration errors
    #[error("Configuration error: {0}")]
    Configuration(String),
    
    /// Bitcoin library errors
    #[error("Bitcoin error: {0}")]
    Bitcoin(String),
    
    /// HTTP errors
    #[error("HTTP error: {0}")]
    Http(String),
    
    /// Generic errors
    #[error("Generic error: {0}")]
    Generic(String),
}

impl Error {
    /// Create a new mining optimization error
    pub fn mining_optimization(msg: impl Into<String>) -> Self {
        Self::MiningOptimization(msg.into())
    }
    
    /// Create a new energy monitoring error
    pub fn energy_monitoring(msg: impl Into<String>) -> Self {
        Self::EnergyMonitoring(msg.into())
    }
    
    /// Create a new generic error
    pub fn generic(msg: impl Into<String>) -> Self {
        Self::Generic(msg.into())
    }
}