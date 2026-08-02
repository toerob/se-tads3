#!/bin/bash
if [ ! -d "past-obj" ]; then
  echo "Skapar upp en tom "past-obj"-katalog som är nödvändig för kompilering"
  mkdir past-obj
fi

# Kör manuellt och granska utfallet av "test run"
t3make -q -f past.t3m && rlwrap frob -k utf8 -i plain past-tests.t3
