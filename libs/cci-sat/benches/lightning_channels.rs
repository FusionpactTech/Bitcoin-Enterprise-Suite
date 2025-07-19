use criterion::{black_box, criterion_group, criterion_main, Criterion};
use cci_sat::LightningChannel;

fn benchmark_lightning_channels(c: &mut Criterion) {
    c.bench_function("lightning_channel_creation", |b| {
        b.iter(|| {
            let channel = LightningChannel::builder()
                .build()
                .unwrap();
            black_box(channel);
        })
    });
}

criterion_group!(benches, benchmark_lightning_channels);
criterion_main!(benches);