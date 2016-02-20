#!/bin/sh

# new gcc (cont.)
cd ~/tmp
# svn ls svn://gcc.gnu.org/svn/gcc/tags # listar releases
svn co svn://gcc.gnu.org/svn/gcc/tags/gcc_5_3_0_release/
cd gcc_5_3_0_release/
./contrib/download_prerequisites
cd ..
mkdir gcc_build
cd gcc_build
../gcc_5_3_0_release/configure --prefix=/usr # default is /usr/local, see https://gcc.gnu.org/install/configure.html
make -j "$(nproc --all)"
make install

#----------------------------------------------------------------------
# Libraries have been installed in:
#    /usr/lib/../lib64

# If you ever happen to want to link against installed libraries
# in a given directory, LIBDIR, you must either use libtool, and
# specify the full pathname of the library, or use the `-LLIBDIR'
# flag during linking and do at least one of the following:
#    - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
#      during execution
#    - add LIBDIR to the `LD_RUN_PATH' environment variable
#      during linking
#    - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
#    - have your system administrator add LIBDIR to `/etc/ld.so.conf'

# See any operating system documentation about shared libraries for
# more information, such as the ld(1) and ld.so(8) manual pages.
#----------------------------------------------------------------------

hash -r # forget about old gcc

# Add new libraries to linker
echo "/usr/lib64" > usrLib64.conf
mv usrLib64.conf /etc/ld.so.conf.d/
ldconfig
