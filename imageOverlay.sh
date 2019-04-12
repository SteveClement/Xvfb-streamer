#!/bin/bash

BASE_OFFSET=1050
BASE_BADGE_OFFSET=120
OFFSET=27
currentOffset=0

BADGES="travis version contributors code-size repo-size issues issues-pr stars forks commit-activity last-commit license"

moveImages () {
  PID=$(pgrep fim)
  currentOffset=$[$BASE_BADGE_OFFSET+$currentOffset]
  for p in $PID; do
    if [[ $(ps u |grep $p |grep -v grep| grep misp-logo.jpg) ]]; then
      WID=`xdotool search --pid ${p}`
      xdotool windowmove $WID $BASE_OFFSET 20
    fi

    for badge in $(echo $BADGES); do
      if [[ $(ps u |grep $p |grep -v grep| grep ${badge}.jpg) ]]; then
        WID=`xdotool search --pid ${p}`
        xdotool windowmove $WID $BASE_OFFSET $currentOffset
        currentOffset=$[$currentOffset+$OFFSET]
      fi
    done
  done
  #echo "Press enter to remove the images, or CTRL-C to exit"
  #read
  exit
}

badges () {
  STYLE="for-the-badge"
  for badge in $(echo $BADGES); do
    rm badges/$badge.svg badges/$badge.jpg
  done
  wget -q -O badges/travis.svg https://img.shields.io/travis/MISP/MISP/2.4.svg?style=$STYLE
  wget -q -O badges/version.svg https://img.shields.io/github/release/MISP/MISP.svg?style=$STYLE
  wget -q -O badges/contributors.svg https://img.shields.io/github/contributors/MISP/MISP.svg?style=$STYLE
  wget -q -O badges/code-size.svg https://img.shields.io/github/languages/code-size/MISP/MISP.svg?style=$STYLE
  wget -q -O badges/repo-size.svg https://img.shields.io/github/repo-size/MISP/MISP.svg?style=$STYLE
  wget -q -O badges/issues.svg https://img.shields.io/github/issues/MISP/MISP.svg?style=$STYLE
  wget -q -O badges/issues-pr.svg https://img.shields.io/github/issues-pr/MISP/MISP.svg?style=$STYLE
  wget -q -O badges/stars.svg https://img.shields.io/github/stars/MISP/MISP.svg?style=$STYLE
  wget -q -O badges/forks.svg https://img.shields.io/github/forks/MISP/MISP.svg?style=$STYLE
  wget -q -O badges/contributors.svg https://img.shields.io/github/contributors-anon/MISP/MISP.svg?style=$STYLE
  wget -q -O badges/last-commit.svg https://img.shields.io/github/last-commit/MISP/MISP.svg?style=$STYLE
  wget -q -O badges/license.svg https://img.shields.io/github/license/MISP/MISP.svg?style=$STYLE

  wget -q -O badges/commit-activity.svg https://img.shields.io/github/commit-activity/w/MISP/MISP.svg?style=$STYLE
  # For a bizarre reason commit-activity is sometimes invalid, this catches that and re-tries until good.
  while true; do
    flag=$(cat badges/commit-activity.svg| grep INVALID; echo $?)
    if [[ "$flag" == "1" ]]; then
      break
    fi
    echo "commit-activity is INVALID, retrying"
    wget -q -O badges/commit-activity.svg https://img.shields.io/github/commit-activity/w/MISP/MISP.svg?style=$STYLE
    sleep 3
  done

  for badge in $(echo $BADGES); do
    convert badges/$badge.svg badges/$badge.jpg
  done
}

echo "Generating badges and displaying them with fim"

##[[ $(pgrep fim) ]] && moveImages

pkill -9 fim
badges
fim -q --autowindow img/misp-logo.jpg &
for badge in $(echo $BADGES); do
  fim -q --autowindow badges/$badge.jpg &
done
sleep 3
moveImages
