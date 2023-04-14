#!/bin/bash
#set -x
EXTENSION=$1
EXTENSION_LIST=("mp4" "mkv" "webm")
[[ $# -eq 0 || $# -gt 1 ]] && printf "Need one video Extension as Argument.\n" \
 && exit 1
echo " ${EXTENSION_LIST[@]} " | grep -Fvzq -- " ${EXTENSION} " \
&& printf "\nNeed a valid video Extension as argument.\n \
Eg: mkv, webm, mp4." && exit 2
#echo $(for i in *.$1; do ffprobe -v quiet -print_format json -show_format "$i" \
#| jq -r ".format.duration"; done | jq -s add | \
#awk '{printf("%.1f Hours\n",$1 / 3600)}')

for i in *.${EXTENSION}
do
fileJson=$(ffprobe -v quiet -print_format json -show_format "$i");
fileName=$(echo $fileJson | jq -r '.[]|.filename')
duration=$(echo $fileJson | jq -r '.[]|.duration')
echo $fileName"       "$(perl -e "print int($duration/60)")min

done