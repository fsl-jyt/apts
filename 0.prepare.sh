#!/bin/bash
set -v on

gcc --version
CUR_GCC_VERSION=`gcc -dumpversion`
if [ $CUR_GCC_VERSION == "6.3.1" ] ; then
  echo "current gcc already is 6.3.1"
  exit 0
fi
yum install -y net-tools vim git wget tree libaio-devel glibc-static.aarch64 libstdc++-static.aarch64 openmpi openmpi-devel libgfortran libgfortran4 dejavu-lgc* bc java-1.8.0-openjdk java-1.8.0-openjdk-devel gcc-gnat* libgnat* gcc-c++ zlib-devel automake autoconf autoscan aclocal libtool

