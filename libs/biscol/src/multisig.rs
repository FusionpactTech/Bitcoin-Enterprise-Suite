//! Multi-signature support for BiSCOL

use crate::Result;

/// Multi-signature configuration
pub struct MultiSig;

/// Builder for multi-signature setups
pub struct MultiSigBuilder;

/// Threshold configuration
pub struct Threshold;

impl MultiSig {
    /// Create a new multi-sig builder
    pub fn builder() -> MultiSigBuilder {
        MultiSigBuilder
    }
}

impl MultiSigBuilder {
    /// Build the multi-sig configuration
    pub fn build(self) -> Result<MultiSig> {
        Ok(MultiSig)
    }
}