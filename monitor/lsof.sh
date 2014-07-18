#!/bin/bash

SAMPLES=$1
INTERVAL=$2

p1=$3
p2=$4


echo "$p1,$p2 " > lsof-process.out
echo " $p1,$p2 "

times=$SAMPLES
while [ $times -gt 0 ] 
do
    lsof_p1=`lsof |grep $p1 |wc -l`
    lsof_p2=`lsof |grep $p2 |wc -l`
    echo "$lsof_p1,$lsof_p2" >> lsof-process.out
    times=$((times-1))
    sleep $INTERVAL
done
