//! Error types for AICRM-SDK

use thiserror::Error;

/// Result type alias for AICRM-SDK operations
pub type Result<T> = std::result::Result<T, Error>;

/// Main error type for AICRM-SDK operations
#[derive(Error, Debug)]
pub enum Error {
    /// Risk analysis errors
    #[error("Risk analysis failed: {0}")]
    RiskAnalysis(String),
    
    /// Compliance check errors
    #[error("Compliance check failed: {0}")]
    Compliance(String),
    
    /// Transaction monitoring errors
    #[error("Transaction monitoring error: {0}")]
    Monitoring(String),
    
    /// Machine learning model errors
    #[error("ML model error: {0}")]
    MlModel(String),
    
    /// Data analytics errors
    #[error("Analytics error: {0}")]
    Analytics(String),
    
    /// Reporting errors
    #[error("Reporting error: {0}")]
    Reporting(String),
    
    /// Database errors
    #[error("Database error: {0}")]
    Database(String),
    
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
    /// Create a new risk analysis error
    pub fn risk_analysis(msg: impl Into<String>) -> Self {
        Self::RiskAnalysis(msg.into())
    }
    
    /// Create a new compliance error
    pub fn compliance(msg: impl Into<String>) -> Self {
        Self::Compliance(msg.into())
    }
    
    /// Create a new generic error
    pub fn generic(msg: impl Into<String>) -> Self {
        Self::Generic(msg.into())
    }
}