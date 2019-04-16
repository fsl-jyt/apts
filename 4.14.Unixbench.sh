#!/bin/bash
set -v on

CUR_FOLDER=$PWD
COUNT_CORES=`cat /proc/cpuinfo | grep processor | wc |  awk '{print $1}'`

cd build
rm -rf UnixBench
tar -zxf ../packages/UnixBench5.1.3.tgz
cd UnixBench
make -j$COUNT_CORES

cat Run | grep "System Benchmarks\", 'maxCopies' =>"
sed -i "s/System Benchmarks\", 'maxCopies' => 16/System Benchmarks\", 'maxCopies' => $COUNT_CORES/g" Run
cat Run | grep "System Benchmarks\", 'maxCopies' =>"
sync
sleep 5
./Run -c 1 -c $COUNT_CORES

if [ $COUNT_CORES == 48 ] ; then
  cat Run | grep "System Benchmarks\", 'maxCopies' =>"
  sed -i "s/System Benchmarks\", 'maxCopies' => 48/System Benchmarks\", 'maxCopies' => 46/g" Run
  cat Run | grep "System Benchmarks\", 'maxCopies' =>"
  sync
  sleep 5
  ./Run -c 46
fi

cd $CUR_FOLDER
