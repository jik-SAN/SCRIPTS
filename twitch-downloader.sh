#!/bin/bash

del_ts() {
find ./ -type f -size 0 -delete
read -p "Delete old Ts files :  " yo;
case $yo in
	y)rm -f *.ts
	 return;;
	*)return;;
esac

}

cd ~/Downloads/twitch-downloads
rm -f *.txt
ls *.ts 2>/dev/null && printf "Warning: ts files from previous download in folder\n" && del_ts
#trap "rm -f *.ts *.txt" EXIT

[ $# -ne 3 ] && printf "\nThis Script requires 3 arguments\n1.Twitch url\n2.Start time (HH.MM)\n3.End time (HH.MM)\n" && exit

rm -f *.txt
echo "🌟🌟🌟--------------TWITCH STREAM DOWNLOADER---------------🌟🌟🌟";

#RANDOM CHARACTERS FOR FILE NAME
#sd=$(cat /dev/urandom | tr -cd 'a-j' | head -c 1);
sd=$(perl -le 'print map { ("a".."z")[rand 26] } 1..4');

url1=$1

#print video details
yt-dlp -F -s -g --print 'pre_process:%(uploader)s %(title)s %(duration>%H:%M:%S)s' --print 'pre_process:%(chapters)s' $url1;

choice="160p 360p 160p30 360p30"
select option in $choice; do
case $REPLY in
	1)
	 lnk=$(yt-dlp -s -g -f 160p $url1 2>/dev/null);
          ab=${lnk%i*};
	 break ;;
	2)
	 lnk=$(yt-dlp -s -g -f 360p $url1 2>/dev/null);
          ab=${lnk%i*};
	 break ;;
	3)
	 lnk=$(yt-dlp -s -g -f 160p30 $url1 2>/dev/null);
          ab=${lnk%i*};
	 break ;;
	4)
	 lnk=$(yt-dlp -s -g -f 360p30 $url1 2>/dev/null);
          ab=${lnk%i*};
	 break ;;
	*)
	 echo "FALSE INPUT TRY AGAIN"
	;;
esac
done

#time
#read -p "enter start time"$'\n' gf;
gf=$2
kh=${gf%.*};
km=${gf#*.};
t2=$(echo "$(( $kh * 354 + $km * 6))")

#read -p "enter end time"$'\n' gn;
gn=$3
kd=${gn%.*};
kx=${gn#*.};
t3=$(echo "$(( $kd * 354 + $kx * 6))")

#aria2c -x4 -P -Z $ab[$t2-$t3].ts


draw_progress_bar() {
   PROGRESS_BAR_WIDTH=53
   BAR='###################################################'
   FILL='---------------------------------------------------'
   local __value=0
   local __max=$(( $t3-$t2 ))
   lt2=$t2
   [ $__max -lt 1 ] && echo "Progress bar max value less than 1 " && exit
   while :
   do
    #T-timeout t - retries --read-timeout - timeout till no activity
   wget -c -4 -q -nc -T 10 --retry-connrefused --read-timeout=5 -t 30 "$ab$lt2.ts" >/dev/null 2>&1
  # Calculate percentage
  local __percentage=$((($__value * 100 / $__max * 100) / 100))
  # Rescale the bar according to the progress bar width
  local __num_bar=$(( $__percentage * $PROGRESS_BAR_WIDTH / 100 ))
  # Draw progress bar
  echo -ne "\r[${BAR:0:$__num_bar}${FILL:$__num_bar:PROGRESS_BAR_WIDTH}] $__value/$__max ($__percentage%)"
  [ $lt2 -eq $t3 ] && break
  (( lt2+=1 )) && (( __value+=1 ))
  done
}

draw_progress_bar
printf "\n\n Download Done \n\n"
printf "\n\n Checking File Integrity \n\n"
#Delete 0 byte files from unfinished downloads
find ./ -type f -size 0 -delete
draw_progress_bar

fd "*ts" -t f --glob | sort -V >> list$sd.txt;
sed -i 's/^/file /' list*.txt;
printf "\n Joining video parts \n"
ffmpeg -loglevel 24 -f concat -i *.txt -c copy -bsf:a aac_adtstoasc ~/Desktop/Tw$sd-$gn.mp4

#espeak -a 2 -vaf+m4 -s 150 "Twitch stream downloaded"

#After Download
#for i in `\ls *.ts | sort -V`; do echo "file '$i'"; done >> list$sd.txt
