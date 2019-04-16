#!/bin/sh
# HXT AE: Auto Performance Test Suite
set -v on

CUR_FOLDER=$PWD
LOG_DATE=`date "+%Y%m%d%H%M%S"`
LOG_PRENAME="log_"$LOG_DATE"_"
COUNT_CORES=`cat /proc/cpuinfo | grep processor | wc |  awk '{print $1}'`

uname -a
pwd
export

./0.prepare.sh
./0.toolchain.sh
cpupower frequency-set -g performance

echo "########## start run test case... ##########"
#ll 4.*.sh | awk '{print $9}' > caselist
cat caselist
cat caselist | while read line
do
CASE_NAME=$line
LOG_NAME=$LOG_PRENAME$CASE_NAME".log"
echo ">>>>>>>>>>"$CASE_NAME" start..`date "+%Y-%m-%d_%H-%M-%S"` <<<<<<<<<<"
./$CASE_NAME $LOG_PRENAME$CASE_NAME 2>&1 | tee $LOG_NAME
echo ">>>>>>>>>>"$CASE_NAME" end..`date "+%Y-%m-%d_%H-%M-%S"` <<<<<<<<<<"
done
echo "########## test case finish! ##########"

