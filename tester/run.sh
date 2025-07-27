#!/bin/bash
if [ ! -d "obj" ]; then
  echo "Skapar upp en tom "obj"-katalog som är nödvändig för kompilering"
  mkdir obj
fi

t3make -f additional.t3m && rlwrap frob -k utf8 -i plain tester.t3
t3make -f initialize.t3m && rlwrap frob -k utf8 -i plain tester.t3
t3make -f past.t3m && rlwrap frob -k utf8 -i plain tester.t3
t3make -f present.t3m && rlwrap frob -k utf8 -i plain tester.t3
t3make -f satsdelar.t3m && rlwrap frob -k utf8 -i plain tester.t3

# Kör manuellt och granska utfallet av "test run"
#t3make -f parser.t3m && rlwrap frob -k utf8 -i plain tester.t3
