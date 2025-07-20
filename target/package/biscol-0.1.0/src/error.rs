//! Error types for BiSCOL

use thiserror::Error;

/// Result type alias for BiSCOL operations
pub type Result<T> = std::result::Result<T, Error>;

/// Main error type for BiSCOL operations
#[derive(Error, Debug)]
pub enum Error {
    /// Script execution errors
    #[error("Script execution failed: {0}")]
    ScriptExecution(String),

    /// Smart contract errors
    #[error("Smart contract error: {0}")]
    SmartContract(String),

    /// Taproot operation errors
    #[error("Taproot operation failed: {0}")]
    Taproot(String),

    /// Multi-signature errors
    #[error("Multi-signature error: {0}")]
    MultiSig(String),

    /// Zero-knowledge proof errors
    #[error("Zero-knowledge proof error: {0}")]
    ZkProof(String),

    /// Compliance check errors
    #[error("Compliance check failed: {0}")]
    Compliance(String),

    /// Bitcoin library errors
    #[error("Bitcoin error: {0}")]
    Bitcoin(String),

    /// Secp256k1 errors
    #[error("Secp256k1 error: {0}")]
    Secp256k1(#[from] secp256k1::Error),

    /// Generic errors
    #[error("Generic error: {0}")]
    Generic(String),
}

impl Error {
    /// Create a new script execution error
    pub fn script_execution(msg: impl Into<String>) -> Self {
        Self::ScriptExecution(msg.into())
    }

    /// Create a new smart contract error
    pub fn smart_contract(msg: impl Into<String>) -> Self {
        Self::SmartContract(msg.into())
    }

    /// Create a new generic error
    pub fn generic(msg: impl Into<String>) -> Self {
        Self::Generic(msg.into())
    }
}
