#!/bin/bash

#---------------------------------------------------------------------------
#
#   author: He Jianfei
#
#   email : smalldegree@163.com  
#
#   date  : 2016-07-08 17:15:00
#
#   description: 
#           1)This script is used to deploy tcpcopy environment.
#
#           2)This script is for CentOS 6.4 x86_64, and installation
#             mode is "Basic Server" with 607 packages.
#
#   history:
#           1)Created by He Jianfei on 2016-07-08 17:15:00.
#
#           2)Modified the way adding the route item instead of 'route add'
#             by He Jianfei on 2016-07-12 09:47:00.
#
#           3)Added the description that the both servers online and
#             assistant should<must> be on the same 2(3) layer switch or 
#             you must add some routes on middle routers in order to make
#             system works.
#
#           4)We strongly suggested that you should specify the value of 
#             the parameter '-c' about tcpcopy with $ip_online, in other
#             words, $ip_client=$ip_online, then you can copy any online
#             server's flux.
#
#---------------------------------------------------------------------------


ip_online="192.168.4.187"
ip_test="192.168.4.209"
ip_assistant="192.168.4.210"
ip_client="192.168.4.110"

source_port="1935"
destination_port="1935"

src_libpcap="libpcap-1.7.4.tar.gz"
src_tcpcopy="tcpcopy-1.0.0.tar.gz"
src_intercept="intercept-1.0.0.tar.gz"


function usage()
{
cat <<END 2>&1

usage: ${0##*/} [t | i | r | si | st]
       t     --   install tcpcopy 
       i     --   install intercept
       r     --   add route on test server
       si    --   start intercept
       st    --   start tcpcopy

01: eg. ${0##*/} t    --  install tcpcopy on online server.
02: eg. ${0##*/} i    --  install intercept on assistant server.
03: eg. ${0##*/} r    --  add route on test server.

05: eg. ${0##*/} si   --  start intercept on assistant server.
06: eg. ${0##*/} st   --  start tcpcopy on online server.

END
}


function install_libpcap()
{
    tar -zxvf $src_libpcap

    cd ${src_libpcap%%.tar.gz}
    
    sh configure
    make && make install
}

function install_tcpcopy()
{
    tar -zxvf $src_tcpcopy

    cd ${src_tcpcopy%%.tar.gz}

    sh configure --with-debug --pcap-capture
    make && make install
}

function install_intercept()
{
    tar -zxvf $src_intercept

    cd ${src_intercept%%.tar.gz}

    sh configure --with-debug --pcap-capture
    make && make install
    
    echo 0 > /proc/sys/net/ipv4/ip_forward
}

function add_route()
{
    echo 1 > /proc/sys/net/ipv4/ip_forward
    #route add -host $ip_client gw $ip_assistant

    /sbin/ip rule add to ${ip_client}/32 table 500
    /sbin/ip r r default via $ip_assistant t 500
    /sbin/ip r l t 500
}

function start_intercept()
{
    interface=$(/sbin/ip addr | sed -n "/$ip_assistant/p" | awk -F ' ' '{print $7}')

    /usr/local/intercept/sbin/intercept -i $interface -F "tcp and src port $destination_port" -d -l /dev/null
}

function start_tcpcopy()
{
    interface=$(/sbin/ip addr | sed -n "/$ip_online/p" | awk -F ' ' '{print $7}')
    
    /usr/local/tcpcopy/sbin/tcpcopy -x ${source_port}-${ip_test}:${source_port} -s $ip_assistant -c $ip_client -i $interface -F "tcp and dst port $destination_port" -d -l /dev/null  
}


[ $# -eq 0 ] && usage && exit


if [ $1 = 't' ]
then
    install_libpcap && cd .. && install_tcpcopy

    [ -e /usr/local/tcpcopy/sbin/tcpcopy ] && echo -e "\033[32mservice tcpcopy has been installed successfully!\033[0m"
elif [ $1 = 'i' ]
then
    install_libpcap && cd .. && install_intercept
    
    [ -e /usr/local/intercept/sbin/intercept ] && echo -e "\033[32mservice intercept has been installed successfully!\033[0m"
elif [ $1 = 'r' ]
then
    add_route

    #route -n | grep "$ip_client" 2>&1 > /dev/null && echo -e "\033[32mstatic route item has been added successfully!\033[0m"
    /sbin/ip r l | grep "$ip_assistant" 2>&1 > /dev/null && echo -e "\033[32mstatic route item has been added successfully!\033[0m"                                                                                                                          
elif [ $1 = 'si' ]
then
    [ -e /usr/local/intercept/sbin/intercept ] && killall -9 intercept 2>&1 > /dev/null
    start_intercept

    ps axu | grep 'intercept' 2>&1 > /dev/null && netstat -atunp | grep 'intercept' 2>&1 > /dev/null && echo -e "\033[32mservice intercept has been started successfully!\033[0m"
elif [ $1 = 'st' ] 
then                                                                                                                                            
    [ -e /usr/local/tcpcopy/sbin/tcpcopy ] && killall -9 tcpcopy 2>&1 > /dev/null
    start_tcpcopy

    ps axu | grep 'tcpcopy' 2>&1 > /dev/null && netstat -atunp | grep 'tcpcopy' 2>&1 > /dev/null && echo -e "\033[32mservice tcpcopy has been startd successfully!\033[0m" 
else
    echo "Unknown parameter."
fi


