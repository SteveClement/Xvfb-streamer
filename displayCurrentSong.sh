#!/usr/bin/env bash

LOUNGE=http://64.71.79.181:5080/stream
ffprobe -v quiet -print_format json -show_format -show_streams $LOUNGE |jq -r '.format | .tags| .StreamTitle' > /tmp/current.song

if [[ "$(cat /tmp/current.song)" != "null" ]] && [[ "$(cat /tmp/current.song)" != "" ]]; then
  echo "Current song: $(cat /tmp/current.song)" | osd_cat -d 120 -A right -p bottom -f  -adobe-helvetica-bold-r-normal--34-240-100-100-p-176-iso8859-1 -c DodgerBlue -s 0
fi
