#!/bin/bash

arraylist=()
#curpath=$(pwd)
curpath="$HOME/.config/bin"
#echo $($curpath)
i=0
for  file in "$curpath"/* 
do
	filename=$(basename $file)
	#echo $filename
	if  [ "$filename" != "starwars" ] && [ "$filename" != "randomterminal.sh" ] && [ "$filename"  != "loopterminal.sh" ]; then
		if [ ! -d "$file" ]; then
			arraylist[$i]=$file
#			echo $file
			i=$((i+1))

		fi
	fi
done
size=${#arraylist[@]}
index=$(($RANDOM % $size))
eval ${arraylist[$index]}
