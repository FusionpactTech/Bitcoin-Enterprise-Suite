use criterion::{black_box, criterion_group, criterion_main, Criterion};
use aicrm_sdk::RiskAnalyzer;

fn benchmark_risk_scoring(c: &mut Criterion) {
    c.bench_function("risk_analyzer_creation", |b| {
        b.iter(|| {
            let analyzer = RiskAnalyzer::builder()
                .with_ml_model(black_box("test_model"))
                .with_threshold(black_box(0.75))
                .build()
                .unwrap();
            black_box(analyzer);
        })
    });
}

criterion_group!(benches, benchmark_risk_scoring);
criterion_main!(benches);