//! Error types for CCI-SAT

use thiserror::Error;

/// Result type alias for CCI-SAT operations
pub type Result<T> = std::result::Result<T, Error>;

/// Main error type for CCI-SAT operations
#[derive(Error, Debug)]
pub enum Error {
    /// Atomic swap errors
    #[error("Atomic swap failed: {0}")]
    AtomicSwap(String),

    /// Lightning Network errors
    #[error("Lightning Network error: {0}")]
    Lightning(String),

    /// Bridge protocol errors
    #[error("Bridge protocol error: {0}")]
    Bridge(String),

    /// Multi-chain wallet errors
    #[error("Multi-chain wallet error: {0}")]
    Wallet(String),

    /// Cross-chain protocol errors
    #[error("Cross-chain protocol error: {0}")]
    Protocol(String),

    /// Network communication errors
    #[error("Network error: {0}")]
    Network(String),

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
    /// Create a new atomic swap error
    pub fn atomic_swap(msg: impl Into<String>) -> Self {
        Self::AtomicSwap(msg.into())
    }

    /// Create a new lightning error
    pub fn lightning(msg: impl Into<String>) -> Self {
        Self::Lightning(msg.into())
    }

    /// Create a new generic error
    pub fn generic(msg: impl Into<String>) -> Self {
        Self::Generic(msg.into())
    }
}
