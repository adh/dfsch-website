# Requirements

To build dfsch from source you need at least following:

 * C compiler with support for ISO C99 and
   `__attribute__((constructor))` GCC extension (preferrably GCC itself) 
 * [Expat XML parser](http://expat.sourceforge.net/)
 * [Boehm-Demers-Weiser conservative garbage collector](http://www.hpl.hp.com/personal/Hans_Boehm/gc/)
 * [Zlib](http://zlib.net/)

Console input subsystem can optionally use [GNU Readline
library](http://gnu.org/readline/). Various extension modules are
enabled or disabled depending on what additional libraries are
detected by build system.

dfsch is tested to build on Debian GNU/Linux on i386 and amd64 and
should work on most Linux systems without any modifications. Windows
builds are produced by crosscompilation using MinGW toolchain with
Linux host system. BSD systems (and possibly other unices) may require
modification of linker options in makefiles.