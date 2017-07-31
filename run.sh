if ! matlab -nodisplay -nojvm -r "test_benchmarks; exit"; then 
sudo octave --no-gui .test_benchmarks.m
fi
