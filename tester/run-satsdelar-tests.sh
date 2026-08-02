#!/bin/bash
if [ ! -d "satsdelar-obj" ]; then
  echo "Skapar upp en tom "satsdelar-obj"-katalog som är nödvändig för kompilering"
  mkdir satsdelar-obj
fi

# Kör manuellt och granska utfallet av "test run"
t3make -q -f satsdelar.t3m && rlwrap frob -k utf8 -i plain satsdelar-tests.t3