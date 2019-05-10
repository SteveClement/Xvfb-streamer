#!/usr/bin/env bash

DELAY=5

showBuildTime () {
  cat /tmp/lastBuild.time |osd_cat -d $DELAY -A left -p bottom -f -adobe-helvetica-bold-r-normal--34-240-100-100-p-176-iso8859-1 -c DodgerBlue -s 0 -o -25
}

showProgress () {
  if [[ -f "/tmp/INSTALL.stat" ]]; then
    PROGRESS=$(cat /tmp/INSTALL.stat|grep progress= |cut -f2 -d=)
    osd_cat -T "Build done ${PROGRESS}%" -b percentage -P ${PROGRESS} -p bottom -f -adobe-helvetica-bold-r-normal--34-240-100-100-p-176-iso8859-1 -c DodgerBlue -s 0
  fi  
}

fetchProgress () {
  portOpen=$(nc -z localhost 2222; echo $?)
  if [[ "$portOpen" == "0" ]]; then
    sshpass -p "Password1234" scp -p 2222 -r misp@localhost:/tmp/INSTALL.stat /tmp/
    showProgress
  fi
}

showBuildTime &
fetchProgress
