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
./lat_mem_rd 4k
./lat_mem_rd 128M
./lat_mem_rd 512M 8192
cd $CUR_FOLDER
