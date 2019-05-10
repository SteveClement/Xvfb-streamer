#!/usr/bin/env bash

# Fetch Configured Radio station from Script

RADIO=$(cat stream-script.sh |grep RADIO= |cut -f 2 -d\$)

if [[ "$RADIO" == "HIPHOP" ]]; then
  # Fetch song for https://www.radio35.cloud/
  HIPHOP="http://64.71.79.181:5234/stream"
  ffprobe -v quiet -print_format json -show_format -show_streams $HIPHOP |jq -r '.format | .tags| .StreamTitle' > /tmp/current.song
fi

if [[ "$RADIO" == "LOUNGE" ]]; then
  # Fetch song for Milano Lounge
  LOUNGE="http://64.71.79.181:5080/stream"
  ffprobe -v quiet -print_format json -show_format -show_streams $LOUNGE |jq -r '.format | .tags| .StreamTitle' > /tmp/current.song
fi

if [[ "$RADIO" == "RADIO100k7" ]]; then
  # Fetch song name for Radio 100,7
  wget --no-cache -q -O song  https://www.100komma7.lu/player
  cat song |grep -1 player-current__name |tail -1 |xargs |sed 's/^/"/' |sed 's/$/"/' > /tmp/current.song
fi

if [[ "$RADIO" == "BEYOND" ]]; then
  # Fetch song name for Beyond Radio
  wget --no-cache -q -O song https://www.beyondradio.co.uk/played-tracks
  awk 'FNR>=823 && FNR<=823' song | sed 's/\&amp;/\&/' |cut -f3 -d= > /tmp/current.song
fi

if [[ "$(cat /tmp/current.song)" != "null" ]] && [[ "$(cat /tmp/current.song)" != "" ]] && [[ "$(cat /tmp/current.song)" != "$(cat /tmp/last.song)" ]]; then
  echo "Current song: $(cat /tmp/current.song)" | osd_cat -d 90 -A right -p bottom -f  -adobe-helvetica-bold-r-normal--34-240-100-100-p-176-iso8859-1 -c DodgerBlue -s 0
else
  echo "Last song is the same then current song"
  sleep 30
fi

cp /tmp/current.song /tmp/last.song
