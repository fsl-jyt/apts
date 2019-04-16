#!/usr/bin/python -tt

#lt reserve rep-001
#lt release rep-001 --force
boardname = "rep-001"
boardaccount = "root"
boardpassword = "jyt"
count = 100
logfileprefix = "log.pspl"

if __name__ == "__main__":
    import os
    import sys
    import time
    import pexpect

    starttime = time.strftime("%Y-%m-%d_%H-%M-%S", time.localtime())
    print "Get ready to test repeated cold start ",count,"times for "+boardname+", "+starttime
    #print os.popen("hostname").readlines()
    print os.popen("lt power --off "+boardname)
    time.sleep(10)
    print "logfile: "+logfileprefix+"."+starttime
    fout = open(logfileprefix+"."+starttime,"a+")
    #if already run lt connect rep-001 by manual, please press ctrl+], then press q for exit.
    #pex = pexpect.spawn("lt connect "+boardname, logfile=sys.stdout)
    pex = pexpect.spawn("lt connect "+boardname, logfile=fout)
    i=1
    while i <= count:
        print "poweron-shutdown-powerdown-loop:",i,"times start"
        os.popen("lt power --on "+boardname)
        pex.expect("login:", timeout=600)
        pex.sendline(boardaccount)
        pex.expect("Password:", timeout=5)
        pex.sendline(boardpassword)
        time.sleep(5)
        pex.sendline("echo 'poweron-shutdown-powerdown-loop: "+str(i)+" times ongoing..."+time.strftime("%Y-%m-%d_%H-%M-%S", time.localtime())+"'")
        time.sleep(5)
        pex.sendline("shutdown now")
        pex.expect("reboot: Power down", timeout=20)
        time.sleep(5)
        os.popen("lt power --off "+boardname)
        time.sleep(10)
        print "poweron-shutdown-powerdown-loop:",i,"times success"
        i = i + 1

    pex.close()
    fout.close()
    print "ok, "+time.strftime("%Y-%m-%d_%H-%M-%S", time.localtime())
    sys.exit(0)
