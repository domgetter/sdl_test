#!/bin/bash

time crystal build --cross-compile --target x86_64-pc-windows-msvc src/sdl_test.cr -o sdl_test.obj --release && \
mv sdl_test.obj.o sdl_test.obj && \
cp sdl_test.obj /mnt/c/Users/domgetter/crystal
