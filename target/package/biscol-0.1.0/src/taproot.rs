//! Taproot implementation for BiSCOL

use crate::Result;

/// Taproot script operations
#[derive(Debug, Clone)]
pub struct TaprootScript;

impl TaprootScript {
    /// Create a new Taproot script
    pub fn new() -> Self {
        TaprootScript
    }
}

impl Default for TaprootScript {
    fn default() -> Self {
        Self::new()
    }
}

/// Builder for Taproot scripts
#[derive(Debug, Clone)]
pub struct TaprootBuilder;

impl TaprootBuilder {
    /// Create a new Taproot builder
    pub fn new() -> Self {
        TaprootBuilder
    }

    /// Build Taproot script
    pub fn build(&self) -> Result<TaprootScript> {
        Ok(TaprootScript::new())
    }
}

impl Default for TaprootBuilder {
    fn default() -> Self {
        Self::new()
    }
}
