use criterion::{black_box, criterion_group, criterion_main, Criterion};
use imo_eo::EnergyMonitor;

fn benchmark_energy_analytics(c: &mut Criterion) {
    c.bench_function("energy_monitor_creation", |b| {
        b.iter(|| {
            let monitor = EnergyMonitor::new();
            black_box(monitor);
        })
    });
}

criterion_group!(benches, benchmark_energy_analytics);
criterion_main!(benches);