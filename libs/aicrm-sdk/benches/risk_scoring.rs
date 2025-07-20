use aicrm_sdk::RiskAnalyzer;
use criterion::{black_box, criterion_group, criterion_main, Criterion};

fn benchmark_risk_scoring(c: &mut Criterion) {
    c.bench_function("risk_analyzer_creation", |b| {
        b.iter(|| {
            let analyzer = RiskAnalyzer::new();
            black_box(analyzer);
        })
    });
}

criterion_group!(benches, benchmark_risk_scoring);
criterion_main!(benches);
