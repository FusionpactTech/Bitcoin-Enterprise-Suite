//! BiSCOL Smart Contract Example
//! 
//! This example demonstrates how to create and execute a Bitcoin-native
//! smart contract using BiSCOL's Taproot integration and multi-signature
//! orchestration.

use biscol::{SmartContract, Script, ExecutionContext, Result};

#[tokio::main]
async fn main() -> Result<()> {
    println!("🔐 BiSCOL Smart Contract Example");
    println!("===============================");

    // Initialize BiSCOL
    biscol::init()?;
    println!("✅ BiSCOL initialized successfully");

    // Create a simple script for demonstration
    let script = Script::from_hex("OP_DUP OP_HASH160")?;
    println!("📝 Created Bitcoin script");

    // Build a smart contract with Taproot and multi-sig
    let contract = SmartContract::builder()
        .with_taproot_script(script)
        .with_multi_sig_threshold(2, 3) // 2-of-3 multisig
        .build()?;
    
    println!("🏗️  Built smart contract with:");
    println!("   - Taproot script integration");
    println!("   - 2-of-3 multi-signature requirement");

    // Create execution context
    let context = ExecutionContext::new();
    println!("⚙️  Created execution context");

    // Execute the contract
    println!("🚀 Executing smart contract...");
    let result = contract.execute(&context).await?;
    
    if result.is_success() {
        println!("✅ Smart contract executed successfully!");
        println!("   - All conditions met");
        println!("   - Multi-signature validated");
        println!("   - Taproot script executed");
    } else {
        println!("❌ Smart contract execution failed");
    }

    println!("\n🎉 BiSCOL example completed!");
    Ok(())
}

/// Example configuration for enterprise deployment
#[allow(dead_code)]
fn enterprise_contract_example() -> Result<SmartContract> {
    // This would be a more complex contract for enterprise use
    let script = Script::from_hex("OP_CHECKSIG OP_VERIFY")?;
    
    SmartContract::builder()
        .with_taproot_script(script)
        .with_multi_sig_threshold(3, 5) // Higher security threshold
        .build()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_smart_contract_creation() {
        let result = enterprise_contract_example();
        assert!(result.is_ok());
    }

    #[test]
    fn test_biscol_initialization() {
        let result = biscol::init();
        assert!(result.is_ok());
    }
}