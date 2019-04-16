#!/bin/bash
if [ ! $1 ]; then
  LOG_PRENAME_CASE_NAME="log_"`date "+%Y%m%d%H%M%S"`"_SpecCPU2006.sh"
else
  LOG_PRENAME_CASE_NAME=$1
fi
set -v on

CUR_FOLDER=$PWD
COUNT_CORES=`cat /proc/cpuinfo | grep processor | wc |  awk '{print $1}'`
#yum -y install -y glibc-static.aarch64 libstdc++-static.aarch64

umount build/SpecCPU2006.iso
rm -rf build/SpecCPU2006* -rf
mkdir build/SpecCPU2006.iso build/SpecCPU2006.iso.cp build/SpecCPU2006.iso.install
mount -o loop packages/cpu2006-1.2.iso build/SpecCPU2006.iso
cp build/SpecCPU2006.iso/* build/SpecCPU2006.iso.cp -rf
sync
umount build/SpecCPU2006.iso
cd build/SpecCPU2006.iso.cp
tar -xf ../../packages/linux-apm-arm64-118.tar
echo -e "yes\n" | ./install.sh -d $CUR_FOLDER/build/SpecCPU2006.iso.install
cd $CUR_FOLDER/build/SpecCPU2006.iso.install
cp $CUR_FOLDER/packages/SpecCPU2006-HXT-arm64*.cfg config/
source ./shrc
ulimit -s unlimited
sync
sleep 5
# about 10 hour for int, 15 hour for fp
#time runspec --rate $COUNT_CORES -c SpecCPU2006-HXT-arm64-gcc.cfg --tune base -o all int
#time runspec --rate $COUNT_CORES -c SpecCPU2006-HXT-arm64-gcc.cfg --tune base -o all fp
# about 10 hour for int, 15 hour for fp
time runspec --rate $COUNT_CORES -c SpecCPU2006-HXT-arm64-tcmalloc.cfg --tune base -o all int
time runspec --rate $COUNT_CORES -c SpecCPU2006-HXT-arm64-tcmalloc.cfg --tune base -o all fp
# single case
#time runspec --rate $COUNT_CORES -c SpecCPU2006-HXT-arm64-gcc.cfg --noreportable 453.povray
#time runspec --rate $COUNT_CORES -c SpecCPU2006-HXT-arm64-tcmalloc.cfg --noreportable 456.hmmer

cp -rf result $CUR_FOLDER/$LOG_PRENAME_CASE_NAME"_result"
grep -r "(R)_rate_base2006" result/ | awk '{print $3,$4}'

cd $CUR_FOLDER

