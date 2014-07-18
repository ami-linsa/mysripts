#!/bin/sh
awk -F, '
	BEGIN{
		min=1999999999;
		max=0;
		total=0;
		counts=0
	};
	{if($1 !~ /TestID/ && $3 ~ /0/){
		total+=$2; 
		counts++; 
		min=$2<min?$2:min; 
		max=$2>max?$2:max;
	}
	fi}; 
	END{
		print "min: " min
		print "max: " max 
		printf "avg: %.2f\n" ,total/counts
	}' data.log
