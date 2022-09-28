#!/bin/bash
if pgrep -x "ffmpeg" > /dev/null
then
    echo FFmpeg is already running
    exit 1
fi

media-ctl -v --device /dev/media0 --set-v4l2 '"ov5640 0-003c":0[fmt:YUYV8_2X8/720x576@1/30]'
amixer --card 1 sset 'Auto Gain Control',0 off
amixer --card 1 sset 'Mic',0 0

CURR_DATE=$(date +%d-%m-%YT%H-%M-%S)
ffmpeg -re -f v4l2 -video_size 720x576 -framerate 30 -i /dev/video0 -f alsa -ac 1 -i hw:1 -vf pad=736:576:8:0 -c:v cedrus264 -c:a libmp3lame -b:a 320k -qp 22 -r 30 -pix_fmt nv12 $CURR_DATE.mkv
