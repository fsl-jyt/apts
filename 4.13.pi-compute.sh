#!/bin/bash
set -v on

CUR_FOLDER=$PWD
COUNT_CORES=`cat /proc/cpuinfo | grep processor | wc |  awk '{print $1}'`

if [ $COUNT_CORES == 48 ] ; then
  time java -jar packages/pi.jar 46
fi
time java -jar packages/pi.jar $COUNT_CORES

