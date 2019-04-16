#!/bin/bash
set -v on

CUR_GCC_VERSION=`gcc -dumpversion`
if [ $CUR_GCC_VERSION == "6.3.1" ] ; then
  echo "current gcc already is 6.3.1"
  exit 0
fi

CUR_FOLDER=$PWD
COUNT_CORES=`cat /proc/cpuinfo | grep processor | wc |  awk '{print $1}'`

## compile gperftools
cd $CUR_FOLDER/build
rm -rf gperftools-2.6.1
tar -zxf ../packages/gperftools-2.6.1.tar.gz
cd gperftools-2.6.1
./configure
make -j$COUNT_CORES
make install prefix=/usr/local
ls -l /usr/local/lib/libtcmalloc*
echo "/usr/local/lib" > /etc/ld.so.conf.d/tcmalloc.conf
ldconfig


#wget http://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz
#gmp-4.3.2.tar.bz2
cd $CUR_FOLDER/build
rm -rf gmp-6.1.2
#rm -rf gmp-4.3.2
tar -xvf $CUR_FOLDER/packages/gmp-6.1.2.tar.xz
#tar -jxf $CUR_FOLDER/packages/gmp-4.3.2.tar.bz2
cd gmp-6.1.2
#cd gmp-4.3.2
#./configure --exec-prefix=/usr
./configure --prefix=/usr --enable-cxx
make -j$COUNT_CORES
make install
ls -l /usr/lib/libgmp*
ls -l /usr/include/gmp.h
echo "/usr/lib" > /etc/ld.so.conf.d/gmp.conf
ldconfig

#wget http://ftp.gnu.org/gnu/mpfr/mpfr-3.1.5.tar.xz
#mpfr-2.4.2.tar.bz2
cd $CUR_FOLDER/build
rm -rf mpfr-3.1.5
#rm -rf mpfr-2.4.2
xz -dk $CUR_FOLDER/packages/mpfr-3.1.5.tar.xz
tar -xvf $CUR_FOLDER/packages/mpfr-3.1.5.tar
#tar -jxf $CUR_FOLDER/packages/mpfr-2.4.2.tar.bz2
cd mpfr-3.1.5
#cd mpfr-2.4.2
#./configure --exec-prefix=/usr
./configure --prefix=/usr --with-gmp=/usr
make -j$COUNT_CORES
make install
ls -l /usr/lib/libmpfr*
echo "/usr/lib" > /etc/ld.so.conf.d/mpfr.conf
ldconfig

#wget http://ftp.vim.org/languages/gcc/infrastructure/mpc-1.0.3.tar.gz
#mpc-0.8.1.tar.gz
cd $CUR_FOLDER/build
rm -rf mpc-1.0.3
#rm -rf mpc-0.8.1
tar -zxvf $CUR_FOLDER/packages/mpc-1.0.3.tar.gz
cd mpc-1.0.3
#tar -zxvf $CUR_FOLDER/packages/mpc-0.8.1.tar.gz
#cd mpc-0.8.1
#./configure --exec-prefix=/usr
./configure --prefix=/usr --with-gmp=/usr --with-mpfr=/usr
make -j$COUNT_CORES
make install
ll /usr/lib/libmpc*
echo "/usr/lib" > /etc/ld.so.conf.d/mpc.conf
ldconfig

#wget http://ftp.tsukuba.wide.ad.jp/software/gcc/infrastructure/isl-0.18.tar.bz2
#wget http://gcc.gnu.org/pub/gcc/infrastructure/isl-0.15.tar.bz2
#isl-0.15.tar.bz2
cd $CUR_FOLDER/build
rm -rf isl-0.18
#rm -rf isl-0.15
tar -jxf $CUR_FOLDER/packages/isl-0.18.tar.bz2
#tar -jxf $CUR_FOLDER/packages/isl-0.15.tar.bz2
cd isl-0.18
#cd isl-0.15
#./configure --exec-prefix=/usr
./configure --prefix=/usr --with-gmp-prefix=/usr
make -j$COUNT_CORES
make install
make install-strip
ls -l /usr/lib/libisl*
echo "/usr/lib" > /etc/ld.so.conf.d/isl.conf
ldconfig

##wget http://ftp.vim.org/languages/gcc/infrastructure/cloog-0.18.1.tar.gz
cd $CUR_FOLDER/build
rm -rf cloog-0.18.1
tar -zxvf $CUR_FOLDER/packages/cloog-0.18.1.tar.gz
cd cloog-0.18.1
./configure --exec-prefix=/usr
make -j$COUNT_CORES
make install
ls -l /usr/bin/cloog
echo "/usr/lib" > /etc/ld.so.conf.d/cloog-0.18.1.conf
ldconfig

export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib:${LD_LIBRARY_PATH}
export LD_RUN_PATH=/usr/lib:/usr/local/lib:${LD_RUN_PATH}
echo "/usr/lib:/usr/local/lib" > /etc/ld.so.conf.d/fortoolchaincompile.conf
ldconfig

#wget gcc-linaro-6.3-2017.02.tar.xz
cd $CUR_FOLDER/build
rm -rf gcc-linaro-6.3-2017.02
#xz -dk $CUR_FOLDER/packages/gcc-linaro-6.3-2017.02.tar.xz
tar -xf $CUR_FOLDER/packages/gcc-linaro-6.3-2017.02.tar
cd gcc-linaro-6.3-2017.02
gcc -v
sed -i "s/ftp/http/g" contrib/download_prerequisites
contrib/download_prerequisites
mkdir build_folder
cd build_folder
## gcc configure:
## 4.8.5	../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,lto --enable-plugin --enable-initfini-array --disable-libgcj --with-isl=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-aarch64-redhat-linux/isl-install --with-cloog=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-aarch64-redhat-linux/cloog-install --enable-gnu-indirect-function --build=aarch64-redhat-linux
## 7.3.1	../configure --enable-bootstrap --enable-languages=c,c++,fortran,lto --prefix=/opt/rh/devtoolset-7/root/usr --mandir=/opt/rh/devtoolset-7/root/usr/share/man --infodir=/opt/rh/devtoolset-7/root/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-shared --enable-threads=posix --enable-checking=release --enable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --enable-plugin --with-linker-hash-style=gnu --enable-initfini-array --with-default-libstdcxx-abi=gcc4-compatible --with-isl=/builddir/build/BUILD/gcc-7.3.1-20180303/obj-aarch64-redhat-linux/isl-install --disable-libmpx --enable-gnu-indirect-function --build=aarch64-redhat-linux


#../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,objc,obj-c++,java,fortran,lto --enable-plugin --enable-initfini-array --disable-libgcj --with-isl=/usr --with-cloog=/usr --with-gmp=/usr --with-mpc=/usr --with-mpfr=/usr --enable-gnu-indirect-function --build=aarch64-unknown-linux-gnu

../configure --enable-bootstrap --enable-languages=c,c++,fortran,lto --prefix=/usr --mandir=/opt/rh/devtoolset-7/root/usr/share/man --infodir=/opt/rh/devtoolset-7/root/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-shared --enable-threads=posix --enable-checking=release --enable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --enable-plugin --with-linker-hash-style=gnu --enable-initfini-array --with-default-libstdcxx-abi=gcc4-compatible --disable-libmpx --enable-gnu-indirect-function --build=aarch64-unknown-linux-gnu


# aarch64-redhat-linux
# aarch64-linux-gnu
# aarch64-unknown-linux-gnu

make -j$COUNT_CORES
make install
make install-strip
/usr/bin/gcc --version
export LD_LIBRARY_PATH=/usr/lib/gcc/aarch64-redhat-linux/6.3.1:${LD_LIBRARY_PATH}
export LD_RUN_PATH=/usr/lib/gcc/aarch64-redhat-linux/6.3.1:${LD_RUN_PATH}
echo "/usr/lib/gcc/aarch64-redhat-linux/6.3.1" > /etc/ld.so.conf.d/gcc-linaro-6.3.conf
ldconfig
gcc --version

cd $CUR_FOLDER

