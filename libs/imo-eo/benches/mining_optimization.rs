use criterion::{black_box, criterion_group, criterion_main, Criterion};
use imo_eo::MiningOptimizer;

fn benchmark_mining_optimization(c: &mut Criterion) {
    c.bench_function("mining_optimizer_creation", |b| {
        b.iter(|| {
            let optimizer = MiningOptimizer::builder()
                .with_target_efficiency(black_box(0.95))
                .with_power_cost(black_box(0.08))
                .build()
                .unwrap();
            black_box(optimizer);
        })
    });
}

criterion_group!(benches, benchmark_mining_optimization);
criterion_main!(benches);