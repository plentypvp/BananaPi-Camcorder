media-ctl -v --device /dev/media0 --set-v4l2 '"ov5640 0-003c":0[fmt:YUYV8_2X8/720x576@1/30]'
ffmpeg -re -f v4l2 -video_size 720x576 -i /dev/video0 -vf pad=736:576:0:0 -c:v cedrus264 -qp 22 -pix_fmt nv12 single_output.mkv
