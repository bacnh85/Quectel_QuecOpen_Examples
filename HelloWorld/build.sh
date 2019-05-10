#!/bin/bash

# Create build directory
if [ ! -d build ]; then
    echo "Create build folder \r\n"
    mkdir build
fi

cd build

if [ ! -f Makefile ]; then
    echo "Makefile is not exist. Run Cmake ... "
    cmake ..
fi

echo "Build program ... \r\n"
make
