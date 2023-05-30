#!/bin/bash
echo "😆 开始处理"
cd input
OLDIFS=$IFS
IFS='
'
if [ ! -d "workdir" ]
then
	echo "😆 创建工作目录"
	mkdir workdir
else
	echo "😅 已存在工作目录"
fi

if [ -d $(ls *.zip | grep "processed" -v) ]
then
	echo "😅 没有待处理文件"
	echo "😅 合流流程结束"
	exit
fi

for zipfile in $(ls *.zip | grep "processed" -v)
do
	outputname=$(basename -s .zip $zipfile)
	unzip -o $zipfile -d workdir
	cd workdir
	file1=$(ls *.mp4 | tail -n 1)
	file2=$(ls *.mp4 | head -n 1)
	size1=$(ls -l "$file1" | awk '{ print $5 }')
	size2=$(ls -l "$file2" | awk '{ print $5 }')
	if [ $size1 -gt $size2 ]
	then
		video=$file1
		audio=$file2
	fi


	if [ $size2 -gt $size1 ]
	then
		video=$file2
		audio=$file1
	fi
	echo $audio
	echo $video
	/usr/bin/ffmpeg -i "$audio" -acodec copy audio.aac
	/usr/bin/ffmpeg -i "$video" -i $(dirname "$audio")/audio.aac -c copy -shortest $outputname.mp4
	mv "$outputname.mp4" ../../output
	echo "😆 "$outputname".mp4 合流完成"
	cd ..
	rm -rf workdir/*
	mv $zipfile "$outputname"_processed.zip
done
echo "😆 合流流程结束"
