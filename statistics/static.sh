#/bin/bash
#############################################################################
# created by linsa 2011/08/11
#############################################################################
if [ $# -ne 2 ]; then
    echo "usage: staticCPU.sh <file_dir> <PID>"
    echo "eg. sh staticCPU.sh qbldata/0811.500_500cw 17188"
    exit
fi

FILE_DIR=$1/tmp
PID=$2

echo "==========================================================================================="
grep $PID $FILE_DIR/top.out > $FILE_DIR/top.log

awk -F " " '{print $9}' $FILE_DIR/top.log > $FILE_DIR/cpu

awk 'BEGIN{a=0;b=0}{a+=$1;b+=1}END{print "Average CPU%: " a/b; print "lines: " b}' $FILE_DIR/cpu

awk -F " " '{print $5 " " $6 " " $10}' $FILE_DIR/top.log > $FILE_DIR/mem
tail -1 $FILE_DIR/mem | awk '{print "Max MEM: VIRT  RES  %MEM" "\n\t" $1 "  " $2 "  " $3}'

echo "network: "
grep "IFACE   rxpck/s" $FILE_DIR/sar.out > $FILE_DIR/net
grep "Average:         eth1" $FILE_DIR/sar.out >> $FILE_DIR/net
head -2 $FILE_DIR/net | awk '{print}'
#awk '{print $0}' $FILE_DIR/net

rm $FILE_DIR/cpu $FILE_DIR/mem $FILE_DIR/net
echo "==========================================================================================="
