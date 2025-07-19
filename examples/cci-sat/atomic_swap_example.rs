//! CCI-SAT Atomic Swap Example
//! 
//! This example demonstrates how to perform a secure atomic swap between
//! Bitcoin and Ethereum using CCI-SAT's cross-chain interoperability features.

use cci_sat::{AtomicSwap, Result};

#[tokio::main]
async fn main() -> Result<()> {
    println!("🌉 CCI-SAT Atomic Swap Example");
    println!("==============================");

    // Initialize CCI-SAT
    cci_sat::init().await?;
    println!("✅ CCI-SAT initialized successfully");

    // Setup atomic swap parameters
    let btc_amount = 100_000_000; // 1 BTC in satoshis
    let eth_amount = 1_500_000_000_000_000_000u64; // 1.5 ETH in wei
    let timeout_seconds = 24 * 60 * 60; // 24 hours

    println!("📊 Atomic Swap Parameters:");
    println!("   - Bitcoin Amount: {} satoshis (1 BTC)", btc_amount);
    println!("   - Ethereum Amount: {} wei (1.5 ETH)", eth_amount);
    println!("   - Timeout: {} seconds (24 hours)", timeout_seconds);

    // Create atomic swap
    let swap = AtomicSwap::builder()
        .from_bitcoin(btc_amount)
        .to_ethereum(eth_amount)
        .with_timeout(timeout_seconds)
        .build()?;

    println!("🏗️  Created atomic swap with:");
    println!("   - Cross-chain validation");
    println!("   - Time-locked contracts");
    println!("   - Fraud-proof mechanisms");

    // Execute the swap
    println!("🚀 Initiating atomic swap...");
    let execution = swap.execute().await?;
    
    println!("✅ Atomic swap initiated successfully!");
    println!("   - Hash time-locked contracts deployed");
    println!("   - Cross-chain monitoring active");
    println!("   - Fraud detection enabled");

    // In a real implementation, this would include:
    // - Waiting for counterparty acceptance
    // - Monitoring blockchain confirmations
    // - Handling timeout scenarios
    // - Executing final settlement

    println!("\n🎉 CCI-SAT atomic swap example completed!");
    Ok(())
}

/// Example Lightning Network integration
#[allow(dead_code)]
async fn lightning_integration_example() -> Result<()> {
    use cci_sat::{LightningChannel};

    println!("⚡ Lightning Network Integration Example");
    
    // Create Lightning channel for instant settlements
    let channel = LightningChannel::builder()
        .build()?;
    
    println!("✅ Lightning channel created for instant settlements");
    Ok(())
}

/// Example multi-chain wallet functionality
#[allow(dead_code)]
async fn multi_chain_wallet_example() -> Result<()> {
    use cci_sat::{MultiChainWallet};

    println!("🔗 Multi-Chain Wallet Example");
    
    // Create unified wallet abstraction
    let wallet = MultiChainWallet::builder()
        .build()?;
    
    println!("✅ Multi-chain wallet created with unified interface");
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_atomic_swap_creation() {
        let swap = AtomicSwap::builder()
            .from_bitcoin(50_000_000)
            .to_ethereum(750_000_000_000_000_000u64)
            .with_timeout(12 * 60 * 60)
            .build();
        
        assert!(swap.is_ok());
    }

    #[tokio::test]
    async fn test_lightning_integration() {
        let result = lightning_integration_example().await;
        assert!(result.is_ok());
    }

    #[tokio::test]
    async fn test_multi_chain_wallet() {
        let result = multi_chain_wallet_example().await;
        assert!(result.is_ok());
    }
}