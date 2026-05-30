#!/bin/bash
if [ ! -d "obj" ]; then
  echo "Skapar upp en tom "obj"-katalog som är nödvändig för kompilering"
  mkdir obj
fi

echo

echo -e "\033[0;32mAdditional-tests\033[0m"
t3make -f additional.t3m && rlwrap frob -k utf8 -i plain tester.t3
echo

echo -e "\033[0;32mInitialize-tests\033[0m"
t3make -f initialize.t3m && rlwrap frob -k utf8 -i plain tester.t3
echo

echo -e "\033[0;32mPast-tests\033[0m"
t3make -f past.t3m && rlwrap frob -k utf8 -i plain tester.t3
echo

echo -e "\033[0;32mPresent-tests\033[0m"
t3make -f present.t3m && rlwrap frob -k utf8 -i plain tester.t3
echo

echo -e "\033[0;32mSatsdelar-tests\033[0m"
t3make -f satsdelar.t3m && rlwrap frob -k utf8 -i plain tester.t3
echo
# Kör manuellt och granska utfallet av "test run"
#t3make -f parser.t3m && rlwrap frob -k utf8 -i plain tester.t3
