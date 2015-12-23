#!/bin/bash

#---------------------------------------------------------------------------
#
#   author: He Jianfei
#
#   email : smalldegree@163.com  
#
#   date  : 2015-12-23 10:30:00
#
#   description: 
#           1)This script is used to build ARM cross_compile environment.
#
#           2)This script is for CentOS 6.4 x86_64, and installation
#             mode is "Basic Server" with 607 packages.
#
#   history:
#           1)Created by He Jianfei on 2015-12-23 10:30:00.
#
#---------------------------------------------------------------------------


#Steps of creating cross_compile environment based on ARM arch on CentOS 6.4 x86_64.
#01.prepare resources and check dependency.
#02.init environment.
#03.compile binutils.
#04.generate kernel headers.
#05.compile gcc first without C lib support.
#06.compile C lib for ARM arch, such as glibc.
#07.compile gcc second with C lib support.
#08.check toolchains config.
#09.test HelloWorld program.


#01.prepare resources and check dependency.
function precheck()
{
    rc=0
    
    echo "Checking packages dependencies:"
    for i in bash grep sed awk perl gcc glibc make coreutils diffutils gettext texinfo
    do
        rpm -qa | grep $i 2>&1 > /dev/null
        rc=$?

        echo "    Checking whether has installed package ${i}: $([ $rc -eq 0 ] && echo yes || echo no)"
        [ ! $rc -eq 0 ] && { echo "Please install package ${i} first." && exit; }
    done

    echo -e "\033[32mDependency packages have been installed already.\033[0m"
    echo ""
}


#02.init environment.
function init_env()
{
    host_os=$(cat /etc/issue | head -n 1)
    host_kernel=$(uname -r)
    host_cpu=$(cat /proc/cpuinfo | grep 'model name' | awk -F ': ' '{print $2}')

    rc_binutils=binutils-2.25.tar.gz

    rc_gcc=gcc-4.4.7.tar.gz
    rc_glibc=glibc-2.11.tar.gz
    rc_glibc_ports=glibc-ports-2.11.tar.gz

    rc_gmp=gmp-4.2.tar.gz
    rc_mpfr=mpfr-2.4.0.tar.gz

    rc_linux_kernel=linux-2.6.32.tar.gz    


    export    TOP_DIR=/root/cross_compile
    export    PRJROOT=$TOP_DIR/embeded_toolchains
    export    TARGET=arm-linux

    export    PREFIX=$PRJROOT/tool_chain
    export    TARGET_PREFFIX=$PREFIX/$TARGET

    export    PATH=$PATH:$PREFIX/bin


    rm -rf $TOP_DIR && mkdir $TOP_DIR
    mkdir $PRJROOT
   
    mkdir $PRJROOT/setup_dir
    mkdir $PRJROOT/src_dir
    
    mkdir $PRJROOT/build_dir
    mkdir $PRJROOT/build_dir/build_binutils
    mkdir $PRJROOT/build_dir/build_gcc
    mkdir $PRJROOT/build_dir/build_glibc
    
    mkdir $PRJROOT/kernel
    
    mkdir $PRJROOT/tool_chain

    mkdir $PRJROOT/doc
    mkdir $PRJROOT/program
    
    
    echo "Checking the files' existence:" 
    for i in $rc_binutils $rc_gcc $rc_glibc $rc_glibc_ports $rc_gmp $rc_mpfr
    do
        if [ -f ./$i ]
        then
            cp ./$i $PRJROOT/setup_dir/ && echo "    File ${i}: exists"
        elif [ -f /tmp/$i ]
        then
            cp ./$i $PRJROOT/setup_dir/ && echo "    File ${i}: exists"
        elif [ -f ~/$i ]
        then
            cp ./$i $PRJROOT/setup_dir/ && echo "    File ${i}: exists"
        else
            echo "    File ${i}: Not found in current dir or /tmp/ or ~/" && exit
        fi
    done

    if [ -f ./$rc_linux_kernel ]
    then
        cp ./$rc_linux_kernel $PRJROOT/kernel/ && echo "    File ${rc_linux_kernel}: exists"
    elif [ -f /tmp/$rc_linux_kernel ]
    then
        cp ./$rc_linux_kernel $PRJROOT/kernel/ && echo "    File ${rc_linux_kernel}: exists"
    elif [ -f ~/$rc_linux_kernel ]
    then
        cp ./$rc_linux_kernel $PRJROOT/kernel/ && echo "    File ${rc_linux_kernel}: exists"
    else
        echo "    File ${rc_linux_kernel}: Not found in current dir or /tmp/ or ~/" && exit
    fi

    echo ""
    for i in $rc_binutils $rc_gcc $rc_glibc $rc_glibc_ports $rc_gmp $rc_mpfr
    do
        echo "    Unziping the file $i ..."
        tar -zxvf $PRJROOT/setup_dir/$i -C $PRJROOT/src_dir/ > /dev/null
    done

    echo "    Unziping the file $rc_linux_kernel ..."
    tar -zxvf $PRJROOT/kernel/$rc_linux_kernel -C $PRJROOT/kernel/ > /dev/null
    
    echo -e "\033[32mInit environment successfully.\033[0m"
}


#03.compile binutils.
function compile_binutils()
{
    echo ""
    echo "Compiling binutils: "

    cd $PRJROOT/build_dir/build_binutils
    sh ../../src_dir/${rc_binutils%%.tar.gz}/configure --prefix=$PREFIX --target=$TARGET

    make && make install

    [ $? -eq 0 ] && echo -e "\033[32mCompiled binutils successfully.\033[0m"
}


#04.generate kernel headers.
function generate_kernel_headers()
{
    echo ""
    echo "Generating kernel headers: "

    

    [ $? -eq 0 ] && echo -e "\033[32mGenerated kernel headers successfully.\033[0m"

}


##05.compile gcc first without C lib support.
#function compile_gcc_without_c_lib()
#{
#
#
#}
#
#
#
##06.compile C lib for ARM arch, such as glibc.
#function compile_c_lib()
#{
#
#}
#
#
##07.compile gcc second with C lib support.
#function compile_gcc_with_c_lib()
#{
#
#}
#
#
#
##08.check toolchains config.
#function postcheck()
#{
#
#}
#
#
##09.test HelloWorld program.
#function test_hello_world()
#{
#
#
#}


precheck

init_env

#compile_binutils

generate_kernel_headers


function usage()
{
cat <<END 2>&1
usage: ${0##*/} [on | off | status]
       on      --   enable ipv6
       off     --   disable ipv6
       status  --   show ipv6 support status
END
}


[ $# -eq 0 ] && usage && exit


