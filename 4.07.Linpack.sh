#!/bin/bash
set -v on

CUR_FOLDER=$PWD
COUNT_CORES=`cat /proc/cpuinfo | grep processor | wc |  awk '{print $1}'`
#yum install -y openmpi openmpi-devel libgfortran libgfortran4
#wget http://www.netlib.org/benchmark/hpl/hpl-2.2.tar.gz
#wget ARM-Compiler-for-HPC.18.2_RHEL_7_aarch64.tar
#wget ARM-Compiler-for-HPC_18.2_AArch64_RHEL_7_aarch64.tar.gz

cd build
rm -rf ARM-Compiler-for-HPC_19.0_AArch64_RHEL_7_aarch64
tar -xf ../packages/Arm-Compiler-for-HPC.19.0_RHEL_7_aarch64.tar
cd ARM-Compiler-for-HPC_19.0_AArch64_RHEL_7_aarch64
echo -e "      yes\n" | ./arm-compiler-for-hpc-19.0_Generic-AArch64_RHEL-7_aarch64-linux-rpm.sh
cd ..
rm -rf hpl-2.2
tar -xf ../packages/hpl-2.2.tar.gz
cd hpl-2.2/setup
sh make_generic
#cp Make.UNKNOWN ../Make.arm
sed -i "/TOPdir       =/d" Make.UNKNOWN
echo "TOPdir       = $CUR_FOLDER/build/hpl-2.2" > ../Make.arm
cat Make.UNKNOWN >> ../Make.arm
cd ..

sed -i "s/arch             = UNKNOWN/arch             = arm/g" Makefile
sed -i "s/arch             = UNKNOWN/arch             = arm/g" Make.top
sed -i "s/ARCH         = UNKNOWN/ARCH         = arm/g" Make.arm
#sed -i "s/TOPdir       = \$(HOME)\/hpl/TOPdir       = $CUR_FOLDER\/build\/hpl-2.2/g" Make.arm
sed -i "s/MPdir        = /MPdir        = \/usr\/lib64\/openmpi/g" Make.arm
sed -i "s/MPinc        = /MPinc        = -I \$(MPdir)\/include/g" Make.arm
sed -i "s/MPlib        = /MPlib        = \$(MPdir)\/lib\/libmpi.so/g" Make.arm
sed -i "s/LAdir        = /LAdir        = \/opt\/arm\/armpl-19.0.0_Cortex-A72_RHEL-7_gcc_8.2.0_aarch64-linux/g" Make.arm
sed -i "s/LAinc        = /LAinc        = -I \$(LAdir)\/include/g" Make.arm
sed -i "s/LAlib        = -lblas/LAlib        = \$(LAdir)\/lib\/libarmpl.so/g" Make.arm
sed -i "s/HPL_OPTS     =/HPL_OPTS     = -march=armv8-a -mtune=cortex-a57 -O3 -floop-optimize -falign-loops -falign-labels -falign-functions -falign-jumps/g" Make.arm
export PATH=/usr/lib64/openmpi/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64:/opt/arm/armpl-19.0.0_Cortex-A72_RHEL-7_gcc_8.2.0_aarch64-linux/lib:/opt/arm/gcc-8.2.0_Generic-AArch64_RHEL-7_aarch64-linux/lib64:${LD_LIBRARY_PATH}
export LD_RUN_PATH=/usr/lib64:/opt/arm/armpl-19.0.0_Cortex-A72_RHEL-7_gcc_8.2.0_aarch64-linux/lib:/opt/arm/gcc-8.2.0_Generic-AArch64_RHEL-7_aarch64-linux/lib64:${LD_RUN_PATH}
echo "/usr/lib64:/opt/arm/armpl-19.0.0_Cortex-A72_RHEL-7_gcc_8.2.0_aarch64-linux/lib:/opt/arm/gcc-8.2.0_Generic-AArch64_RHEL-7_aarch64-linux/lib64" > /etc/ld.so.conf.d/armpl.conf
ldconfig

make -j$COUNT_CORES
cd bin/arm
sync
sleep 5
#config HPL.dat ...
#mpirun -np $COUNT_CORES --mca btl sm,self --bind-to core --map-by core --allow-run-as-root ./xhpl
rm -rf HPL.dat
cp $CUR_FOLDER/packages/HPL.dat.42 HPL.dat -rf
mpirun -np 42 --mca btl sm,self --bind-to core --map-by core --allow-run-as-root ./xhpl
sync
sleep 5
rm -rf HPL.dat
cp $CUR_FOLDER/packages/HPL.dat.44 HPL.dat -rf
mpirun -np 44 --mca btl sm,self --bind-to core --map-by core --allow-run-as-root ./xhpl
sync
sleep 5
rm -rf HPL.dat
cp $CUR_FOLDER/packages/HPL.dat.46 HPL.dat -rf
mpirun -np 46 --mca btl sm,self --bind-to core --map-by core --allow-run-as-root ./xhpl
sync
sleep 5
if [ $COUNT_CORES == 48 ] ; then
  rm -rf HPL.dat
  cp $CUR_FOLDER/packages/HPL.dat.48 HPL.dat -rf
  mpirun -np 48 --mca btl sm,self --bind-to core --map-by core --allow-run-as-root ./xhpl
fi

cd $CUR_FOLDER
