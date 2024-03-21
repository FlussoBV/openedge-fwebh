#!/bin/bash

scriptpath=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

ANT_HOME=/usr/dlc/ant; export ANT_HOME
DLC=/usr/dlc; export DLC
PATH=$PATH:$DLC:$DLC/bin; export PATH

# if DLC need to be set to anything other than $DLC append below: -DDLC=/usr/dlc 
if [ "$EXECUTE_UNITTESTS" = "true" ]; then
  unittestExpr="-DexecuteUnittests=${EXECUTE_UNITTESTS}"
fi

${ANT_HOME}/bin/ant -f ${scriptpath}/../build.xml -lib /usr/dlc/pct ${unittestExpr}
