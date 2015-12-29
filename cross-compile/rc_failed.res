
Notice: there are some errors.

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

