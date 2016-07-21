#!/usr/bin/env bash

LLVM_BIN=build/llvm/bin
case $OSTYPE in
  darwin*) 
    EXT=dylib
    ;;
  linux*)
    EXT=so
    ;;
  *)
    echo "Could not detect OS (${OSTYPE})"
    exit 2
    ;;
esac


if [ ! -d ${LLVM_BIN} ]; then
  echo "[!] LLVM not found. Run ./build.sh"
  exit 1
fi

echo "[+] Compiling tests..."
${LLVM_BIN}/clang -o tests/test1.bc tests/test1.c -c -emit-llvm -Wall -Wshadow -Wextra
${LLVM_BIN}/clang -o tests/test1 tests/test1.c -Wall -Wshadow -Wextra

echo "[+] Running screen pass..."
${LLVM_BIN}/opt -load build/lib/screen.${EXT} tests/test1.bc -o tests/test1_xformed.bc -screen -screen-output OUTPUT

echo
echo
echo "[+] Verifying paths:"
echo "B1: main-> printf-> fun1-> anno-> printf-> anno-> printf-> printf"
echo "B2: main-> printf-> foo-> printf-> printf"
echo
echo