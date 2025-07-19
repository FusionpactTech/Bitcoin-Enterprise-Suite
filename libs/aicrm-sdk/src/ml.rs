//! Machine learning models for AICRM-SDK

use crate::{Error, Result};

/// ML model interface
pub struct MlModel;

impl MlModel {
    /// Create a new ML model
    pub fn new() -> Self {
        MlModel
    }
}