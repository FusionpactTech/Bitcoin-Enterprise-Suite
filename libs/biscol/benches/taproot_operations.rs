use criterion::{black_box, criterion_group, criterion_main, Criterion};
use biscol::TaprootScript;

fn benchmark_taproot_operations(c: &mut Criterion) {
    let taproot_script = TaprootScript::new();
    
    c.bench_function("taproot_operations", |b| {
        b.iter(|| {
            // Benchmark taproot operations
            black_box(&taproot_script);
        })
    });
}

criterion_group!(benches, benchmark_taproot_operations);
criterion_main!(benches);