#!/bin/bash

title=()
title=(`find . -name '*\).mp3' | cut -d'(' -f 1-2 | cut -d')' -f 1-2`)

for t in ${title[@]}
  do
    echo $t
    ffmpeg -i "$t"*.mp3 -c copy "$t".mp3
  done
