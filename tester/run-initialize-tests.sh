#!/bin/bash
if [ ! -d "init-obj" ]; then
  echo "Skapar upp en tom "init-obj"-katalog som är nödvändig för kompilering"
  mkdir init-obj
fi

# Kör manuellt och granska utfallet av "test run"
t3make -q -f initialize.t3m && rlwrap frob -k utf8 -i plain initialize-tests.t3
