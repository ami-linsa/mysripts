#! /bin/sh


awk -F, '{if($5 !~ /Test/ && $6 ~ /0/) print $5}' $1 | sort -n > test


lineNum=`cat test | wc -l`

echo "lineNum : $lineNum"

awk -F, '{if($5 !~ /Test/ && $6 ~ /0/) {sum+=$5;line++}};END{ print "AVG : " sum/line}' $1

a=0.7

line=`expr $lineNum*$a|bc`

b=${line%%.*} 
echo "70% : `sed -n -e ''"$b"'p' test`"

a=0.8

line=`expr $lineNum*$a|bc`

b=${line%%.*}
echo "80% : `sed -n -e ''"$b"'p' test`"

a=0.9

line=`expr $lineNum*$a|bc`

b=${line%%.*}

echo "90% : `sed -n -e ''"$b"'p' test`"

echo "MAX : `sed -n -e ''"$lineNum"'p' test`"

echo "MIN : " `sed -n -e '1''p' test`

last=`expr $lineNum - 10`
echo $last
echo "last 10 : "
echo "`sed -n -e ''"$last"','"$lineNum"'p' test`"

#rm test
