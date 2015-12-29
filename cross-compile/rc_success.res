
Checking the env and files after all configs:
arm-linux-addr2line
arm-linux-ar
arm-linux-as
arm-linux-c++
arm-linux-c++filt
arm-linux-cpp
arm-linux-elfedit
arm-linux-g++
arm-linux-gcc
arm-linux-gcc-4.4.7
arm-linux-gccbug
arm-linux-gcov
arm-linux-gprof
arm-linux-ld
arm-linux-ld.bfd
arm-linux-nm
arm-linux-objcopy
arm-linux-objdump
arm-linux-ranlib
arm-linux-readelf
arm-linux-size
arm-linux-strings
arm-linux-strip
catchsegv
gencat
getconf
getent
iconv
ldd
locale
localedef
mtrace
pcprofiledump
rpcgen
sprof
tzselect
xtrace

[32mCompiled gcc with c lib support can work successfully.[0m

arm-linux-size helloworld
   text	   data	    bss	    dec	    hex	filename
 476104	   1940	   6392	 484436	  76454	helloworld

[32mCongratulations, your cross_compile has worked now.[0m

Configs as follow:

    01.the script is used to build ARM cross_compile env based on CentOS 6.4 x86_64.

    02.the main used resources as follow: default, you can use others
        *binutils: binutils-2.25.tar.gz 
        
        *gcc: gcc-4.4.7.tar.gz
        *glibc: glibc-2.11.tar.gz
        *glibc_ports: glibc-ports-2.11.tar.gz

        *gmp: gmp-4.2.tar.gz
        *mpfr: mpfr-2.4.0.tar.gz

        *linux_kernel: linux-2.6.32.27.tar.gz

    03.the env as follow:
        TOP_DIR: /root/cross_compile
        PRJROOT: /root/cross_compile/embeded_toolchains
        TARGET : arm-linux
        
        PREFIX : /root/cross_compile/embeded_toolchains/tool_chain
        TARGET_PREFIX: /root/cross_compile/embeded_toolchains/tool_chain/arm-linux

        PATH   : /usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/cross_compile/embeded_toolchains/tool_chain/bin
    
    04.the host info:
        host_os:     CentOS release 6.4 (Final)
        host_kernel: 2.6.32-358.el6.x86_64
        host_cpu:    Intel(R) Pentium(R) CPU G3240 @ 3.10GHz

