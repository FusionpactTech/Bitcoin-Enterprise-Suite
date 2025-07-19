use criterion::{black_box, criterion_group, criterion_main, Criterion};
use cci_sat::AtomicSwap;

fn benchmark_atomic_swaps(c: &mut Criterion) {
    c.bench_function("atomic_swap_creation", |b| {
        b.iter(|| {
            let swap = AtomicSwap::builder()
                .from_bitcoin(black_box(50_000_000))
                .to_ethereum(black_box(750_000_000_000_000_000u64))
                .with_timeout(black_box(24 * 60 * 60))
                .build()
                .unwrap();
            black_box(swap);
        })
    });
}

criterion_group!(benches, benchmark_atomic_swaps);
criterion_main!(benches);