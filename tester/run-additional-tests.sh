#!/bin/bash
if [ ! -d "additional-obj" ]; then
  echo "Skapar upp en tom "additional-obj"-katalog som är nödvändig för kompilering"
  mkdir additional-obj
fi

# Kör manuellt och granska utfallet av "test run"
t3make -q -f additional.t3m && rlwrap frob -k utf8 -i plain additional-tests.t3
