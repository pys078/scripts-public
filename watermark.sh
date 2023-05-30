#!/bin/bash
echo "😆 开始处理"
cd output
OLDIFS=$IFS
IFS='
'
num=0
for file in $(ls *.mp4)
do
	if [ ! -e "../output_watermark/$file" ]
	then
		num=$((num+1))
		echo "😆 处理第"$num"份视频 "$file" "
		ffmpeg -hwaccel cuda -i "$file" -c:v h264_nvenc -vf "something_here_to_replace" -preset slow ../output_watermark/$file
	else
		echo "😅 "$file" 这一份视频处理过了"
	fi
done
echo "😆 加水印流程结束"
