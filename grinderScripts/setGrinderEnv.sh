#!/bin/sh
export GRINDERPATH=/home/qatest/linsa/grinder-3.11/bin
export GRINDERPROPERTIES=$GRINDERPATH/grinder.properties
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64
export CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/jconsole.jar:$CLASSPATH;

flist2=`ls /home/qatest/linsa/grinder-3.11/lib/*.jar`

for jar2 in $flist2
do
	CLASSPATH=$CLASSPATH:$jar2
done

export CLASSPATH
