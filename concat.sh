#!/bin/bash

cd new

title=()
title=(`find . -name '*\).mp3' | cut -d'(' -f 1-2 | cut -d')' -f 1-2`)
echo ${title[@]}

for t in ${title[@]}
  do
    echo $t
    mp3s=($(ls "$t("*.mp3))
    e=""
    for m in ${mp3s[@]}
      do
         e="$e|${m}"
      done
    e=${e:1}
    ffmpeg -i "concat:$e" -acodec copy "$t".mp3
  done
