#!/bin/bash

CXX=icpc
#CXX=g++

MATLAB_INC=/Applications/MATLAB_R2012a.app/extern/include
MATLAB_LIB=/Applications/MATLAB_R2012a.app/bin/maci64
MATLAB_EXT=/Applications/MATLAB_R2012a.app/extern/lib/maci64/mexFunction.map

OPENCV_INC=/usr/local/include
OPENCV_LIB=/usr/local/lib

$CXX mexKmeans.cpp -I$MATLAB_INC -lmx -lmex -lmat -L$MATLAB_LIB -bundle -Wl,-exported_symbols_list,$MATLAB_EXT -I$OPENCV_INC -L$OPENCV_LIB -lopencv_core -o mexKmeans.mexmaci64



