#!/bin/bash
if [ ! $1 ]; then
  LOG_PRENAME_CASE_NAME="log_"`date "+%Y%m%d%H%M%S"`"_SpecJVM.sh"
else
  LOG_PRENAME_CASE_NAME=$1
fi
set -v on

#yum -y install dejavu-lgc* java*
#https://www.spec.org/download.html SPECjvm2008_1_01_setup.jar
#wget http://spec.cs.miami.edu/downloads/osg/java/SPECjvm2008_1_01_setup.jar
#java -jar SPECjvm2008_1_01_setup.jar -i console

CUR_FOLDER=$PWD
COUNT_CORES=`cat /proc/cpuinfo | grep processor | wc |  awk '{print $1}'`
export JAVA_HOME=/usr/lib/jvm/java
rm -rf /SPECjvm2008
echo -e "\n\n\n\n\n\n\n\n\nY\n\n\n\n\n" | java -jar packages/SPECjvm2008_1_01_setup.jar -i console
echo "===================================================================="
cd /SPECjvm2008
sync
sleep 5
java -jar SPECjvm2008.jar -ict -ikv startup.helloworld startup.compiler.compiler startup.compress startup.crypto.aes startup.crypto.rsa startup.crypto.signverify startup.mpegaudio startup.scimark.fft startup.scimark.lu startup.scimark.monte_carlo startup.scimark.sor startup.scimark.sparse startup.serial startup.sunflow startup.xml.transform startup.xml.validation compress crypto.aes crypto.rsa crypto.signverify derby mpegaudio scimark.fft.large scimark.lu.large scimark.sor.large scimark.sparse.large scimark.fft.small scimark.lu.small scimark.sor.small scimark.sparse.small scimark.monte_carlo serial sunflow xml.validation xml.transform

cp -rf results $CUR_FOLDER/$LOG_PRENAME_CASE_NAME"_results" -rf
#grep  "composite result:" results/SPECjvm2008.001/SPECjvm2008.001.txt | awk '{print $4}'
grep  "composite result:" results/SPECjvm2008.001/SPECjvm2008.001.txt
cd $CUR_FOLDER

