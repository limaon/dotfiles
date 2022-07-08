#!/usr/bin/env bash
INRES="1366x768"
OUTRES="1366x768"
FPS="30"
#libnp3lame

if pidof ffmpeg
    then 
        killall ffmpeg
        dunstify 'Stopped Recording!' --icon=dialog-information
    else

    time=$(date +%F%T)

    # notify-send 'Started Recording!' --icon=dialog-information
    # ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0 -f alsa -ac 1 \
    #     -i default -vcodec libx264 -s "$OUTRES" \
    #     -acodec ac3_fixed  -ab 128k -ar 44100 \
    #     -threads 0 -qp 18 -preset ultrafast ~/Videos/recording-$time.mp4

    notify-send 'Started Recording!' --icon=dialog-information
    ffmpeg -f x11grab -s "$INRES" -r "$FPS" -thread_queue_size 512 -i :0.0 -f alsa -ac 1 \
        -i default -vcodec libx264 -s "$OUTRES" \
        -acodec ac3_fixed  -ab 128k -ar 44100 \
        -qp 18 -preset ultrafast ~/Videos/recording-$time.mp4
fi
