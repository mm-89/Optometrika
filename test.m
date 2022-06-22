function test

bench = Bench;
eye = Eye_test();
eye.spec_eye(6, 60);
bench.append( eye );
bench.draw();

end