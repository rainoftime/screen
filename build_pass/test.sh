#!/usr/bin/env bash

echo "[+] Compiling tests..."
./llvm-3.8.0/build/Release+Asserts/bin/clang -o tests/test1.bc tests/test1.c -c -emit-llvm -Wall -Wshadow -Wextra
./llvm-3.8.0/build/Release+Asserts/bin/clang -o tests/test1 tests/test1.c -Wall -Wshadow -Wextra

echo "[+] Running Screen Pass pass..."

if [[ "${OSTYPE}" == darwin* ]]; then
	./llvm-3.8.0/build/Release+Asserts/bin/opt -load llvm-3.8.0/build/Release+Asserts/lib/Screen Pass.dylib tests/test1.bc -o tests/test1_transformed.bc -internchallenge
else
	./llvm-3.8.0/build/Release+Asserts/bin/opt -load llvm-3.8.0/build/Release+Asserts/lib/Screen Pass.so tests/test1.bc -o tests/test1_transformed.bc -internchallenge
fi

echo "[+] Created tests/test1_transformed.bc"

echo "[+] Compiling test1_transformed.bc to native executable..."
./llvm-3.8.0/build/Release+Asserts/bin/llc tests/test1_transformed.bc -o tests/test1_transformed.o -filetype=obj 
./llvm-3.8.0/build/Release+Asserts/bin/clang -o tests/test1_transformed tests/test1_transformed.o

echo "[?] Please verify test/test1's output matches test/test1_transformed"

echo "[-] test/test1 results:"
chmod +x ./tests/test1
./tests/test1

echo "[-] test/test1_transformed results:"
chmod +x ./tests/test1_transformed
./tests/test1_transformed
