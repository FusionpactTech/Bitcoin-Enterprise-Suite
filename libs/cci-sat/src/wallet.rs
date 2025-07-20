//! Multi-chain wallet for CCI-SAT

use crate::Result;

/// Multi-chain wallet
pub struct MultiChainWallet;

/// Wallet builder
pub struct WalletBuilder;

impl MultiChainWallet {
    /// Create a new wallet builder
    pub fn builder() -> WalletBuilder {
        WalletBuilder
    }
}

impl WalletBuilder {
    /// Build the wallet
    pub fn build(self) -> Result<MultiChainWallet> {
        Ok(MultiChainWallet)
    }
}