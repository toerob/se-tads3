#!/bin/bash
if [ ! -d "present-obj" ]; then
  echo "Skapar upp en tom "present-obj"-katalog som är nödvändig för kompilering"
  mkdir present-obj
fi

# Kör manuellt och granska utfallet av "test run"
t3make -q -f present.t3m && rlwrap frob -k utf8 -i plain present-tests.t3
