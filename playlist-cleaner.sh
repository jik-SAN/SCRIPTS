#!/bin/bash

#[[ $# -eq 0 || ! -f $1 || ! -e $1 ]] && echo "Need a link as argument!!!!" && exit

printf "\n"
echo $@ | tr ' '  '\n' | sed 's/\&list=[[:alpha:]].\+\&index\=[[:digit:]]\+//g' | tr '\n' ' '
#cat $1 && echo -e "\n"
#rm -f $1
