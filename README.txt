	HXT: Auto Performance Test Suite

1. Prepare
Install all of RPMs as 0.prepare.sh

2. Update Linaro gcc
The default GCC is: gcc (Linaro GCC 6.3-2017.02) 6.3.1 20170109
If not the version 6.3.1, it will build and install them.

3. SW/HW ENV
CentOS 7.6 on /dev/sda
12 HDD for fio full disk test.

4. RUN
./apts.sh
#Get the corresponding log files log_xxx for each case.

5. Folder/file introduction
build: Work folder for each case.
packages: Pre-downloaded SW packages.
caselist: The cases list to run.
*.sh: Performance test cases script.
log_201903xx.tgz: Log files for cases.
tools: Other tools
  - mk.USB-auto-install-CentOS.sh : a tool of make the USB auto install CentOS

6. Known issue:
6.1 Sometimes, after run the 4.07.Linpack.sh, the apts.sh quit and other case behind the Linpack in caselist is not executed.
6.2 Sometimes, in 4.11.fio.sh, the iostat monitor process can not be effectively killed and terminated, which leads to the increasing of FIO full disk read-write log.

Chang log:
20190320, version 0.1, by Jiang Yutang.
