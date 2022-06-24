function test

bench = Bench;
eye = Eye_test();
eye.spec_eye(3, 60);
bench.append( eye );

rays_in = Rays( 1000, 'source-Lambert', [-150 0 0], [ 1 0 0 ], 0.01, 'random', 'air' );
rays_through = bench.trace( rays_in );
bench.draw(rays_through,'lines' );

end