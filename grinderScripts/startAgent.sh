#!/bin/bash

#. /home/space/grinder-3.2/etc/stopAgent.sh

source /home/qatest/linsa/grinder-3.11/bin/setGrinderEnv.sh

echo "begin: `date` " > grinder.output
nohup java -cp $CLASSPATH net.grinder.Grinder $GRINDERPROPERTIES >> grinder.output 2>&1 &

