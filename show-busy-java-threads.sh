#!/bin/bash
# @Function
# Find out the highest cpu consumed threads of java, and print the stack of these threads.
#
# @Usage
#   $ ./show-busy-java-threads.sh
#
# @author Jerry Lee

PROG=`basename $0`

usage() {
    cat <<EOF
Usage: ${PROG} [OPTION]...
Find out the highest cpu consumed threads of java, and print the stack of these threads. must be specify!
Example: ${PROG} -p 1010

Options:
    -p, --pid       find out the highest cpu consumed threads from the specifed java process,
                    default from all java process.must be specify!
    -c, --count     set the thread count to show, default is 5
    -h, --help      display this help and exit
EOF
    exit $1
}

ARGS=`getopt -n "$PROG" -a -o c:p:h -l count:,pid:,help -- "$@"`
[ $? -ne 0 ] && usage 1
eval set -- "${ARGS}"

while true; do
    case "$1" in
    -c|--count)
        count="$2"
        shift 2
        ;;
    -p|--pid)
        pid="$2"
        shift 2
        ;;
    -h|--help)
        usage
        ;;
    --)
        shift
        break
        ;;
    esac
done

echo "pid: " $pid
if [ ! -n "$pid" ]; then
   usage
   exit
fi
count=${count:-5}

redEcho() {
    [ -c /dev/stdout ] && {
        # if stdout is console, turn on color output.
        echo -ne "\033[1;31m"
        echo -n "$@"
        echo -e "\033[0m"
    } || echo "$@"
}

# Check the existence of jstack command!
if ! which jstack &> /dev/null; then
    [ -z "$JAVA_HOME" ] && {
        redEcho "Error: jstack not found on PATH!"
        exit 1
    }
    ! [ -f "$JAVA_HOME/bin/jstack" ] && {
        redEcho "Error: jstack not found on PATH and $JAVA_HOME/bin/jstack file does NOT exists!"
        exit 1
    }
    ! [ -x "$JAVA_HOME/bin/jstack" ] && {
        redEcho "Error: jstack not found on PATH and $JAVA_HOME/bin/jstack is NOT executalbe!"
        exit 1
    }
    export PATH="$JAVA_HOME/bin:$PATH"
fi

uuid=`date +%s`_${RANDOM}_$$

#cleanupWhenExit() {
#    rm /tmp/${uuid}_* &> /dev/null
#}
#trap "cleanupWhenExit" EXIT

printStackOfThread() {
    	jstackFile=/tmp/${uuid}_${pid}
	echo "jstack file: " $jstackFile
	
	[ ! -f "${jstackFile}" ] && {
	    jstack ${pid} > ${jstackFile} || {
                redEcho "Fail to jstack java process ${pid}!"
		}
	    }

	while read threadLine ; do
        #pid=`echo ${threadLine} | awk '{print $1}'`
        threadId=`echo ${threadLine} | awk '{print $1}'`
        threadId0x=`printf %x ${threadId}`
        user=`echo ${threadLine} | awk '{print $2}'`
        pcpu=`echo ${threadLine} | awk '{print $9}'`
        
	
        #jstackFile=/tmp/${uuid}_${pid}
        
        #[ ! -f "${jstackFile}" ] && {
        #    jstack ${pid} > ${jstackFile} || {
        #        redEcho "Fail to jstack java process ${pid}!"
        #        rm ${jstackFile}
        #        continue
        #    }
        #}

        redEcho "Busy(${pcpu}%) thread(${threadId}/0x${threadId0x}) stack of java process(${pid}) under user(${user}):"
        sed "/nid=0x${threadId0x}/,/^$/p" -n ${jstackFile}
    done
}
top -p $pid -H -n 1 -b > /tmp/top.out
cat /tmp/top.out |awk '$12=="java"{print $0}'|sort -k9 -r -n|head --lines 5|printStackOfThread


