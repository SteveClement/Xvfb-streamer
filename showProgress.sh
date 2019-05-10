#!/usr/bin/env bash

DELAY=30

showBuildTime () {
  cat /tmp/lastBuild.time |osd_cat -d $DELAY -A left -p bottom -f -adobe-helvetica-bold-r-normal--34-240-100-100-p-176-iso8859-1 -c DodgerBlue -s 0 -o -45
}

showProgress () {
  if [[ -f "/tmp/INSTALL.stat" ]]; then
    PROGRESS=$(cat /tmp/INSTALL.stat|grep progress= |cut -f2 -d=)
    osd_cat -d $DELAY -T "Build done ${PROGRESS}%" -b percentage -P ${PROGRESS} -p bottom -f -adobe-helvetica-bold-r-normal--34-240-100-100-p-176-iso8859-1 -c DodgerBlue -s 0
  fi  
}

fetchProgress () {
  portOpen=$(nc -z localhost 2222; echo $?)
  if [[ "$portOpen" == "0" ]]; then
    sshpass -p "Password1234" scp -q -P 2222 -o 'GlobalKnownHostsFile=/dev/null' -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' misp@localhost:/tmp/INSTALL.stat /tmp/
    if [[ "$?" == "0" ]]; then
      showProgress
    fi
  fi
}

showBuildTime &
fetchProgress
