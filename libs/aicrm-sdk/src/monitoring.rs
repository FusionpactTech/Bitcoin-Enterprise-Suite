//! Transaction monitoring for AICRM-SDK

use crate::{Error, Result};

/// Transaction monitor
pub struct TransactionMonitor;

/// Alert manager
pub struct AlertManager;

impl TransactionMonitor {
    /// Create a new transaction monitor
    pub fn new() -> Self {
        TransactionMonitor
    }
}