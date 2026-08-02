#!/bin/bash
if [ ! -d "obj" ]; then
  echo "Skapar upp en tom "obj"-katalog som är nödvändig för kompilering"
  mkdir obj
fi

echo

echo -e "\033[0;32mAdditional-tests\033[0m"
bash run-additional-tests.sh
echo
echo

echo -e "\033[0;32mInitialize-tests\033[0m"
bash run-initialize-tests.sh
echo
echo

echo -e "\033[0;32mPast-tests\033[0m"
bash run-past-tense-tests.sh
echo
echo

echo -e "\033[0;32mPresent-tests\033[0m"
bash run-present-tense-tests.sh
echo
echo

echo -e "\033[0;32mSatsdelar-tests\033[0m"
bash run-satsdelar-tests.sh
echo
echo

# Kör manuellt och granska utfallet av "test run"
#t3make -f parser.t3m && rlwrap frob -k utf8 -i plain tester.t3
