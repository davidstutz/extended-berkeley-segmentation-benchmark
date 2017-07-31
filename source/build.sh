if !  matlab -nodisplay -nojvm -r "build; exit" ; then
echo "Matlab Not Found, Trying Octave"
if mkoctfile correspondPixels.cc csa.cc kofn.cc match.cc Exception.cc Matrix.cc Random.cc String.cc Timer.cc -Wno-format-security -O3 -Wno-format -Wno-write-strings -DNOBLAS --mex ; then
echo "Octave Found, Build Successful"
else
echo "Kindly Install either Matlab or Octave"
fi
fi
echo "Moving output artifacts"
cp -f correspondPixels.mex* ../benchmarks/
echo "Done, to run benchmark run 'source ./run.sh'"
cd ..
