#!/bin/bash

cd new

title=()
title=(`find . -name '*\).mp3' | cut -d'(' -f 1-2 | cut -d')' -f 1-2`)
echo ${title[@]}

for t in ${title[@]}
  do
    mp3s=($(ls "$t("*.mp3))
    t="$t".mp3
    echo $t
    echo "" > tmp
    for m in ${mp3s[@]}
      do
         #ffmpeg -i "concat:$t|$m" -i $m -y -acodec copy $t
         echo file $m >> tmp
      done
    
     ffmpeg -f concat -i tmp -y -acodec copy $t
  done
