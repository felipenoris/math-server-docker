# Julia
#https://github.com/JuliaLang/julia/blob/master/README.arm.md

apt-get -y install clang

cd

git clone https://github.com/JuliaLang/julia.git

cd julia

#For Raspberry Pi 2, which is ARMv7, the default build should work.
#However, the CPU type is also not detected by LLVM.
#Fix this by adding JULIA_CPU_TARGET=cortex-a7 to Make.user file.

echo "JULIA_CPU_TARGET=cortex-a7" > Make.user

make USECLANG=1 -j 4 && make USECLANG=1 -j 4 && make USECLANG=1 -j 4  && make USECLANG=1 -j 4

#For Raspberry Pi 2, which is ARMv7, the default build should work. However, the CPU type is also not detected by LLVM. Fix this by adding JULIA_CPU_TARGET=cortex-a7 to Make.user.

#Depending on the exact compiler and distribution, there might be a build failure due to unsupported inline assembly. In that case, add MARCH=armv7-a to Make.user.


#If building LLVM fails, you can download binaries from the LLVM website:

#Download the LLVM 3.7.0 binaries for ARMv7a and extract them in a local directory.
# http://llvm.org/releases/3.7.0/clang+llvm-3.7.0-armv7a-linux-gnueabihf.tar.xz
#Add the following to Make.user (adjusting the path to the llvm-config binary):

#override USE_SYSTEM_LLVM=1
#LLVM_CONFIG=${EXTRACTED_LOCATION}/bin/llvm-config

# download files make -C deps getall

#Issue to compile julia
#Makefile:18: armv7l/Make.files: No such file or directory
#make[2]: *** No rule to make target 'armv7l/Make.files'. Stop.
#Makefile:841: recipe for target 'openlibm/libopenlibm.so' failed
#make[1]: *** [openlibm/libopenlibm.so] Error 2
#Makefile:51: recipe for target 'julia-deps' failed
#make: *** [julia-deps] Error 2
#pi@raspberrypi:~/Documents/julia-0.4 $ find . -iname 'Make.file's
#'./deps/openlibm/src/Make.files
#./deps/openlibm/amd64/Make.files
#./deps/openlibm/ia64/Make.files
#./deps/openlibm/sparc64/Make.files
#./deps/openlibm/i387/Make.files
#./deps/openlibm/arm/Make.files
#./deps/openlibm/mips/Make.files
#./deps/openlibm/ld80/Make.files
#./deps/openlibm/powerpc/Make.files
#./deps/openlibm/bsdsrc/Make.files
#./deps/openlibm/ld128/Make.files

#Solucao:
#Editei ./deps/openlibm/Make.inc inculindo apos definicao de ARCH

#ifeq(ARCH, armv7l)
#ARCH=arm
#endif

#Depois retirei ARCH=$(ARCH) da parte de compilacao do openlibm
#No arquivo deps/Makefile

#Problema: gcc -dumpmachine retorna armv7l em vez de arm-unknown...

#Outro problema: falha em julia-deps libgit2
#.../julia-0.4/deps/libgit2/build/gcc: Command not found
#Resolvido: criando link simbolico

#compilando julia com comando
#make USECLANG=1