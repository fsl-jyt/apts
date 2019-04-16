#!/bin/bash

if [ ! $1 ]; then
  LOG_PRENAME_CASE_NAME="log_"`date "+%Y%m%d%H%M%S"`"_fio.sh"
else
  LOG_PRENAME_CASE_NAME=$1
fi
set -v on

#https://github.com/axboe/fio/releases?after=fio-3.4
CUR_FOLDER=$PWD
COUNT_CORES=`cat /proc/cpuinfo | grep processor | wc |  awk '{print $1}'`
DEV_SINGLE="/dev/sdb"
RUNTIME_SINGLE=1800
RUNTIME_FULL=300

if [ ! -e "build/fio-fio-2.17/fio" ] ; then
  cd build
  rm -rf fio-fio-2.17
  tar -zxf ../packages/fio-fio-2.17.tar.gz
  cd fio-fio-2.17
  ./configure
  make -j$COUNT_CORES
  make install
  cd $CUR_FOLDER
fi

#single disk 4k randread/randwrite, 30min
fio --name=global --ioengine=libaio --bs=4k --rw=randread --filename=$DEV_SINGLE --runtime=$RUNTIME_SINGLE --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting
fio --name=global --ioengine=libaio --bs=4k --rw=randwrite --filename=$DEV_SINGLE --runtime=$RUNTIME_SINGLE --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting

#single disk 1024k randread/randwrite, 30min
fio --name=global --ioengine=libaio --bs=1024k --rw=read --filename=$DEV_SINGLE --runtime=$RUNTIME_SINGLE --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting
fio --name=global --ioengine=libaio --bs=1024k --rw=write --filename=$DEV_SINGLE --runtime=$RUNTIME_SINGLE --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting

#full disk 4k randread 5min, /dev/sdb - /dev/sdl
exec iostat -xm 2 > $LOG_PRENAME_CASE_NAME"_fio_read_all_4k_randread.log" &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randread --filename=/dev/sdb --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randread --filename=/dev/sdc --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randread --filename=/dev/sdd --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randread --filename=/dev/sde --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randread --filename=/dev/sdf --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randread --filename=/dev/sdg --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randread --filename=/dev/sdh --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randread --filename=/dev/sdi --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randread --filename=/dev/sdj --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randread --filename=/dev/sdk --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
fio --name=global --ioengine=libaio --bs=4k --rw=randread --filename=/dev/sdl --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting
sleep 2
sync
ps -elf | grep iostat
PID_IOSTAT=`ps -elf | grep "iostat -xm 2" | head -n 1 | awk '{print $4}'`
echo ==========$PID_IOSTAT
kill -9 $PID_IOSTAT
ps -elf | grep iostat

#full disk 4k randwrite 5min, /dev/sdb - /dev/sdl
exec iostat -xm 2 > $LOG_PRENAME_CASE_NAME"_fio_read_all_4k_randwrite.log" &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randwrite --filename=/dev/sdb --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randwrite --filename=/dev/sdc --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randwrite --filename=/dev/sdd --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randwrite --filename=/dev/sde --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randwrite --filename=/dev/sdf --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randwrite --filename=/dev/sdg --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randwrite --filename=/dev/sdh --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randwrite --filename=/dev/sdi --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randwrite --filename=/dev/sdj --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=4k --rw=randwrite --filename=/dev/sdk --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
fio --name=global --ioengine=libaio --bs=4k --rw=randwrite --filename=/dev/sdl --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting
sleep 2
sync
ps -elf | grep iostat
PID_IOSTAT=`ps -elf | grep "iostat -xm 2" | head -n 1 | awk '{print $4}'`
echo ==========$PID_IOSTAT
kill -9 $PID_IOSTAT
ps -elf | grep iostat

#full disk 1024k read 5min, /dev/sdb - /dev/sdl
exec iostat -xm 2 > $LOG_PRENAME_CASE_NAME"_fio_read_all_1024k_read.log" &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=read --filename=/dev/sdb --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=read --filename=/dev/sdc --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=read --filename=/dev/sdd --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=read --filename=/dev/sde --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=read --filename=/dev/sdf --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=read --filename=/dev/sdg --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=read --filename=/dev/sdh --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=read --filename=/dev/sdi --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=read --filename=/dev/sdj --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=read --filename=/dev/sdk --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
fio --name=global --ioengine=libaio --bs=1024k --rw=read --filename=/dev/sdl --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting
sleep 2
sync
ps -elf | grep iostat
PID_IOSTAT=`ps -elf | grep "iostat -xm 2" | head -n 1 | awk '{print $4}'`
echo ==========$PID_IOSTAT
kill -9 $PID_IOSTAT
ps -elf | grep iostat

#full disk 1024k write 5min, /dev/sdb - /dev/sdl
exec iostat -xm 2 > $LOG_PRENAME_CASE_NAME"_fio_read_all_1024k_write.log" &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=write --filename=/dev/sdb --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=write --filename=/dev/sdc --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=write --filename=/dev/sdd --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=write --filename=/dev/sde --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=write --filename=/dev/sdf --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=write --filename=/dev/sdg --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=write --filename=/dev/sdh --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=write --filename=/dev/sdi --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=write --filename=/dev/sdj --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
exec fio --name=global --ioengine=libaio --bs=1024k --rw=write --filename=/dev/sdk --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting &
fio --name=global --ioengine=libaio --bs=1024k --rw=write --filename=/dev/sdl --runtime=$RUNTIME_FULL --direct=1 --time_based -numjobs=1  -iodepth=32 --name=job --group_reporting
sleep 2
sync
ps -elf | grep iostat
PID_IOSTAT=`ps -elf | grep "iostat -xm 2" | head -n 1 | awk '{print $4}'`
echo ==========$PID_IOSTAT
kill -9 $PID_IOSTAT
ps -elf | grep iostat

