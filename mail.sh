#!/bin/sh

#if [ $# -ne 2 ]; then
#    echo "usage: mail.sh <RCPTTO> <Subject>"
#    exit
#fi

smail(){
    echo $1 $2 $3
    smtp="abc.com 25" # 邮件服务器地址+25端口
    smtp_domain="" # 发送邮件的域名，即@后面的
    FROM="" # 发送邮件地址
    RCPTTO=$1 # 收件人地址
    username_base64="" # 用户名base64编码
    password_base64="" # 密码base64编码
    #local_ip=`ifconfig|grep Bcast|awk -F: '{print $2}'|awk -F " " '{print $1}'|head -1`
    #local_name=`uname -n`
    ( for i in "ehlo $smtp_domain" "AUTH LOGIN" "$username_base64" "$password_base64" "MAIL FROM:<$FROM>" "RCPT TO:<$RCPTTO>" "DATA";do
         echo $i
        sleep 2
     done
     echo "Subject:<$2>"
     echo "Mail From:<$FROM>"
     echo "RCPT To:<$RCPTTO>"
     echo "\n"
     echo $3
     #echo "server $local_name up, ip:$local_ip"
     echo "."
     sleep 2
     echo "quit" )|telnet $smtp
}

subject=`/bin/hostname`
body='testtttttttttttttttttttttt'
smail abc@abc.com $subject $body
