#!/bin/bash
if [ ! -d "obj" ]; then
  echo "Skapar upp en tom "obj"-katalog som är nödvändig för kompilering"
  mkdir obj
fi

# Kör manuellt och granska utfallet av "test run"
t3make -f present.t3m && rlwrap frob -k utf8 -i plain tester.t3
