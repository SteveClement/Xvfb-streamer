#!/bin/bash

source secrets.sh

streaming() {
     INRES="2560x1440" # input resolution
     OUTRES="2560x1440" # output resolution
     INRES="1280x720"
     OUTRES="1280x720"
     FPS="15" # target FPS
     GOP="30" # i-frame interval, should be double of FPS, 
     GOPMIN="15" # min i-frame interval, should be equal to fps, 
     THREADS="4" # max 6
     CBR="1000k" # constant bitrate (should be between 1000k - 3000k)
     QUALITY="ultrafast"  # one of the many FFMPEG preset
     AUDIO_RATE="44100"
     SERVER="live-sjc" # twitch server in California, see http://bashtech.net/twitch/ingest.php to change 
     SERVER="live-tyo"
     SOURCE="x11grab"
     X11Screen=":99.0"
     AUDIO="alsa"
     AUDIO="mp3"
     AUDIODEV="pulse"
     AUDIODEV="pipe:"
     AUDIOOPT="flv"
     AUDIOOPT="s16le"
     CHANNELS="-ac 2" # 2 AudioChannels, 1 is mono
     THREADQSIZE="-thread_queue_size 1024"
     LOUNGE="http://64.71.79.181:5080/stream"
     HIPHOP="http://64.71.79.181:5234/stream"
     CREATIVE="http://149.255.59.3:8008/stream"
     if [[ "$1" == "twitch" ]]; then
        UPSTREAM="rtmp://$SERVER.twitch.tv/app/$STREAM_KEY_TWITCH"
     elif [[ "$1" == "youtube" ]]; then
        UPSTREAM="rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY_YOUTUBE"
     else
        echo "Chose twitch OR youtube"
        exit -1
     fi

     # Stream mp3 from pipe
#     cat Nctrnm_-_Number.mp3 | ffmpeg -f mp3 -i pipe: -c:a pcm_s16le -f s16le 

     # Restream rtmp to youtube
#     ffmpeg -probesize 100M -analyzeduration 20M -re \ 
#            -i "http://source.rtmp.server/hls/stream.m3u8" -strict -2 -c:v \ 
#            libx264 -pix_fmt yuv420p -c:a aac -map 0:0 -map 0:1 -ar 44100 \ 
#            -ab 128k -ac 2 -b:v 2567k -flags +global_header -bsf:a aac_adtstoasc \ 
#            -bufsize 1000k -f flv "rtmp://a.rtmp.youtube.com/live2/xxxx-xxxx-xxxx-xxxx"
     
     # Xvfb :99

     ffmpeg \
       $THREADQSIZE -draw_mouse 0 -f "$SOURCE" -s "$INRES" -r "$FPS" -i "$X11Screen" \
       $THREADQSIZE -re -i $LOUNGE -f flv -ac 2 -ar $AUDIO_RATE  -c:a aac\
       -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
       -s $OUTRES -preset $QUALITY -tune film -acodec libmp3lame -threads $THREADS -strict normal \
       -flags +global_header -bufsize $CBR \
       $UPSTREAM

#     ffmpeg -re -i http://64.71.79.181:5234/stream -draw_mouse 0 -f $SOURCE -i $X11Screen -c:v copy -c:a aac -ar 44100 -ab 128k -ac 2 -strict -2 -flags +global_header -bsf:a aac_adtstoasc -bufsize 3000k -f flv \
#       "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"


     # scriptOutPut |perl -e 'while (<>) {$l++;if (time > $e) {$e=time;print "$l\n";$l=0}}'

#      ffmpeg -i pipe:0 -f mp3 icecast://source:"$2"@localhost:8000/"$1" -loglevel warning
#     cat ~/Music/Nctrnm_-_Number.aac | ffmpeg \
#       -f "$SOURCE" -s "$INRES" -r "$FPS" -i "$X11Screen"\
#       -f "$AUDIO" -i "$AUDIODEV" -c:a pcm_s16le\
#       -f "$AUDIOOPT" $CHANNELS -ar $AUDIO_RATE\
#       -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
#       -s $OUTRES -preset $QUALITY -tune film -acodec libmp3lame -threads $THREADS -strict normal\
#       -bufsize $CBR "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"
     #ffmpeg -f "$SOURCE" -s "$INRES" -r "$FPS" -i "$X11Screen" -f alsa -i pulse -f flv -ac 2 -ar $AUDIO_RATE \
     #  -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
     #  -s $OUTRES -preset $QUALITY -tune film -acodec libmp3lame -threads $THREADS -strict normal \
     #  -bufsize $CBR "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"
 }

streaming $1
