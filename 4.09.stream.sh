#!/bin/bash
set -v on

CUR_FOLDER=$PWD
COUNT_CORES=`cat /proc/cpuinfo | grep processor | wc |  awk '{print $1}'`

cd build
rm -rf lmbench-3.0-a9
tar -zxf ../packages/lmbench-3.0-a9.tgz
cd lmbench-3.0-a9
make build
cd bin
sync
sleep 5
./stream -v 1 -P 1 -M 1024M
./stream -v 1 -P 20 -M 1024M
./stream -v 1 -P 46 -M 1024M
if [ $COUNT_CORES == 48 ] ; then
  ./stream -v 1 -P 48 -M 1024M
fi
sync
sleep 5
./stream -v 2 -P 1 -M 1024M
./stream -v 2 -P 20 -M 1024M
./stream -v 2 -P 46 -M 1024M
if [ $COUNT_CORES == 48 ] ; then
  ./stream -v 2 -P 48 -M 1024M
fi
sync
sleep 5
./stream -v 1 -P24 -M 256M
./stream -v 2 -P24 -M 256M

cd $CUR_FOLDER
