#!/bin/bash
if pgrep -x "ffmpeg" > /dev/null
then
    echo FFmpeg is already running
    exit 1
fi

CONFIG_FILE=streaming_target.conf
if [[ -f $CONFIG_FILE && -s $CONFIG_FILE ]]
then
    echo Reading configuration file...
else
    echo Configuration file $CONFIG_FILE not found or is empty
    exit 1
fi
TARGET=$(cat $CONFIG_FILE)

media-ctl -v --device /dev/media0 --set-v4l2 '"ov5640 0-003c":0[fmt:YUYV8_2X8/720x576@1/30]'
amixer --card 1 sset 'Auto Gain Control',0 off
amixer --card 1 sset 'Mic',0 0

while true
do
    ffmpeg -re -f v4l2 -video_size 720x576 -framerate 30 -i /dev/video0 -f alsa -ac 1 -i hw:1 -vf pad=736:576:8:0 -c:v cedrus264 -c:a libmp3lame -b:a 320k -qp 24 -r 30 -pix_fmt nv12 -f mpegts tcp://$TARGET:2000/
    sleep 1.2
done
