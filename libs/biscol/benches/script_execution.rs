use criterion::{black_box, criterion_group, criterion_main, Criterion};
use biscol::{Script, ExecutionContext};

fn benchmark_script_execution(c: &mut Criterion) {
    let script = Script::from_hex("OP_DUP OP_HASH160").unwrap();
    let context = ExecutionContext::new();
    
    c.bench_function("script_execution", |b| {
        b.iter(|| {
            // Benchmark script execution
            black_box(&script);
            black_box(&context);
        })
    });
}

criterion_group!(benches, benchmark_script_execution);
criterion_main!(benches);