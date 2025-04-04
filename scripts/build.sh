#!/bin/bash

scriptpath=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

ANT_HOME=/usr/dlc/ant; export ANT_HOME
DLC=/usr/dlc; export DLC
PATH=$PATH:$DLC:$DLC/bin; export PATH

# if DLC need to be set to anything other than $DLC append below: -DDLC=/usr/dlc 
if [ "$EXECUTE_UNITTESTS" = "true" ]; then
  unittestExpr="-DexecuteUnittests=true"
fi

${ANT_HOME}/bin/ant -f ${scriptpath}/../build.xml -Dtmpdir=/usr/wrk -lib /usr/dlc/pct ${unittestExpr} 

$DLC/bin/prolib /app/artifacts/fwebh.pl -list > /app/artifacts/fwebh-rcode.list
