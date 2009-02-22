#
# $Id$
#

#**********************************************************
# Makefile for Harbour Project for MSVC compilers
#**********************************************************

# ---------------------------------------------------------------
# Copyright 2007 Marek Paliwoda (mpaliwoda "at" interia "dot" pl)
# See doc/license.txt for licensing terms.
# ---------------------------------------------------------------

# ---------------------------------------------------------------
# If you need to set additional compiler/linker options use the
# environment variables below, but please DON'T MODIFY THIS FILE
# for this purpose.
# ---------------------------------------------------------------

#
# NOTE: You can use these envvars to configure the make process:
#       (note that these are all optional)
#
#       HB_USER_CFLAGS    - Extra C compiler options for libraries and for executables
#       HB_USER_LDFLAGS   - Extra linker options for libraries
#       HB_USER_PRGFLAGS  - Extra Harbour compiler options
#
#       HB_BUILD_DLL      - If set to yes enables building harbour VM+RTL
#                           dll in addition to normal static build
#       HB_BUILD_DEBUG    - If set to yes causes to compile with debug info
#       HB_BUILD_VERBOSE  - Controls echoing commands being executed
#       HB_BUILD_OPTIM    - Setting it to 'no' disables compiler optimizations
#       HB_REBUILD_PARSER - If set to yes force preprocessing new rules by
#                           Bison (you must use Bison 2.3 or later)
#       HB_INSTALL_PREFIX - Path to installation directory into which
#                           Harbour will be installed when using 'install'
#                           mode. Defaults to current directory
#
#       HB_VISUALC_VER    - Version of Visual C++ compiler.
#                           Possible values are: 60, 70, 71, 80 (default), 90
#       HB_BUILD_WINCE    - If set to yes, a WinCE build will be created.

#**********************************************************

.SUFFIXES:

#**********************************************************

HB_ARCHITECTURE = win

#**********************************************************

# Visual C++ version
!ifndef HB_VISUALC_VER
HB_VISUALC_VER = 80
!endif

#**********************************************************

!if "$(HB_BUILD_WINCE)" == "yes"
!if $(HB_VISUALC_VER) >= 80
CC     = cl.exe
!else
CC     = clarm.exe
!endif
!else
CC     = cl.exe
!endif
LINKER = link.exe
MKLIB  = lib.exe

#**********************************************************

# Include Common Object list files
# shared between MSVC and Borland

!include common.mak

#**********************************************************

.SUFFIXES: $(EXEEXT) $(LIBEXT) $(OBJEXT) .prg .c .l .y

#**********************************************************

# Some definitions cannot be kept in common.mak
# due to serious limitations of Microsoft Nmake

# Nmake does not support macros in string
# substitution, so we have to hardcode it

# TOFIX: This won't work properly if HB_CC_NAME is overridden by user (f.e. for WinCE builds).
!if "$(HB_BUILD_WINCE)" == "yes"
VMMTDLL_LIB_OBJS = $(VM_DLL_OBJS:obj\vcce=obj\vcce\mt_dll)
VMMT_LIB_OBJS = $(VM_LIB_OBJS:obj\vcce=obj\vcce\mt)
DLL_OBJS = $(TMP_DLL_OBJS:obj\vcce=obj\vcce\dll) $(VM_DLL_OBJS:obj\vcce=obj\vcce\dll)
MTDLL_OBJS = $(TMP_DLL_OBJS:obj\vcce=obj\vcce\dll) $(VMMTDLL_LIB_OBJS)
!else
VMMTDLL_LIB_OBJS = $(VM_DLL_OBJS:obj\vc=obj\vc\mt_dll)
VMMT_LIB_OBJS = $(VM_LIB_OBJS:obj\vc=obj\vc\mt)
DLL_OBJS = $(TMP_DLL_OBJS:obj\vc=obj\vc\dll) $(VM_DLL_OBJS:obj\vc=obj\vc\dll)
MTDLL_OBJS = $(TMP_DLL_OBJS:obj\vc=obj\vc\dll) $(VMMTDLL_LIB_OBJS)
!endif

#**********************************************************
# C compiler, Harbour compiler and Linker flags.
#**********************************************************

ARFLAGS = /nologo $(HB_USER_AFLAGS)

# C Compiler Flags
!if "$(HB_BUILD_WINCE)" == "yes"

!if "$(HB_BUILD_OPTIM)" != "no"
!if $(HB_VISUALC_VER) >= 80
CFLAGS_VER     = -Od -Os -Gy -EHsc- -Gm -Zi -GR-
!else
CFLAGS_VER     = -Oxsb1 -EHsc -YX -GF
!endif
!endif

# TOFIX: These should be cleaned from everything not absolutely necessary:

CFLAGS         = -nologo -W3 -I$(INCLUDE_DIR) -I$(CFLAGS_VER) \
                 -D"_WIN32_WCE=0x420" -D"UNDER_CE=0x420" -DWIN32_PLATFORM_PSPC \
                 -DWINCE -D_WINCE -D_WINDOWS -DARM -D_ARM_ -DARMV4 \
                 -DPOCKETPC2003_UI_MODEL -D_M_ARM -DUNICODE -D_UNICODE \
                 $(HB_USER_CFLAGS) -D_UWIN -I$(OBJ_DIR)

#-----------
!ifndef HB_WINCE_COMPILE_WITH_GTWIN
CFLAGS         = $(CFLAGS) -DHB_NO_WIN_CONSOLE
!endif
#-----------
!if "$(HB_BUILD_DEBUG)" == "yes"
DBGMARKER = d
!endif

!else

# NOTE: See here: http://msdn.microsoft.com/en-us/library/fwkeyyhe.aspx

!if "$(HB_BUILD_OPTIM)" != "no"
!if $(HB_VISUALC_VER) >= 80
CFLAGS_VER     = -Ot2b1 -EHs-c-
!else
CFLAGS_VER     = -Ogt2yb1p -GX- -G6 -YX
!endif
!endif

CFLAGS         = -nologo -W4 -wd4127 -Gs -I$(INCLUDE_DIR) $(CFLAGS_VER) \
                 $(HB_USER_CFLAGS) -I$(OBJ_DIR)

#-----------
!if "$(HB_BUILD_DEBUG)" == "yes"
CFLAGS         = -Zi -DHB_TR_LEVEL_DEBUG $(CFLAGS)
DBGMARKER      =  d
!endif

CFLAGSMT = -MT$(DBGMARKER) -DHB_MT_VM
# NOTE: -GA flag should be disabled when building MT _.dlls_,
#       as it creates bad code according to MS docs [vszakats].
!if $(HB_VISUALC_VER) >= 70
CFLAGSMT = $(CFLAGSMT) -GA
!endif

!endif

#**********************************************************

CLIBFLAGS      = -c $(CFLAGS)
CLIBFLAGSDLL   = $(CLIBFLAGS) -DHB_DYNLIB
CEXEFLAGSDLL   = $(CLIBFLAGS)
!if "$(HB_BUILD_WINCE)" != "yes"
CLIBFLAGSDLL   = $(CLIBFLAGSDLL) -MT$(DBGMARKER)
CEXEFLAGSDLL   = $(CEXEFLAGSDLL) -MT$(DBGMARKER)
!endif

#**********************************************************

# Linker Flags
!if "$(HB_BUILD_WINCE)" == "yes"
LDFLAGS        = /nologo /subsystem:windowsce,4.20 /machine:arm /armpadcode \
                 /stack:65536,4096 /nodefaultlib:"oldnames.lib" \
                 /nodefaultlib:"kernel32.lib" /align:4096 /opt:ref /opt:icf \
                 /libpath:$(LIB_DIR) $(HB_USER_LDFLAGS)
!if $(HB_VISUALC_VER) >= 80
LDFLAGS        = $(LDFLAGS) /manifest:no
!endif
LDFLAGSDLL     = /dll \
                 /nologo /subsystem:windowsce,4.20 /machine:arm /armpadcode \
                 /stack:65536,4096 /nodefaultlib:"oldnames.lib" \
                 /libpath:$(LIB_DIR) $(HB_USER_LDFLAGS)
STANDARD_SYSLIBS = coredll.lib corelibc.lib winsock.lib ws2.lib
!else
LDFLAGS        = /nologo /libpath:$(LIB_DIR) $(HB_USER_LDFLAGS)
LDFLAGSDLL     = /dll $(LDFLAGS)
!if $(HB_VISUALC_VER) >= 80
LDFLAGS        = $(LDFLAGS) /nxcompat
!endif
# user32.lib: *Clipboard*(), CharToOemBuff(), OemToCharBuff(), GetKeyState(), GetKeyboardState(), SetKeyboardState()
# wsock32.lib: hbinet
# advapi32.lib: GetUserName()
# gdi32.lib: gtwvt
STANDARD_SYSLIBS = user32.lib wsock32.lib advapi32.lib gdi32.lib
!endif

!if "$(HB_BUILD_DEBUG)" == "yes"
LDFLAGS        = /debug $(LDFLAGS)
LDFLAGSDLL     = /debug $(LDFLAGSDLL)
!endif

#**********************************************************
# COMPILE Rules
#**********************************************************

#*******************************************************
# General *.c --> *.obj COMPILE rules for STATIC Libraries
#*******************************************************
{$(OBJ_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(MAIN_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(COMMON_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(COMPILER_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(PP_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(VM_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(RTL_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(MACRO_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(DEBUG_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(LANG_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(CODEPAGE_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(PCRE_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(HBZLIB_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(HBEXTERN_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(RDD_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(NULSYS_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(DBFNTX_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(DBFNSX_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(DBFCDX_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(DBFFPT_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(HBSIX_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(HSX_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(USRRDD_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(HBUDDALL_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(GTCGI_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(GTPCA_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(GTSTD_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(GTWIN_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(GTWVT_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(GTGUI_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(COMPILER_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(HBRUN_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(HBTEST_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(HBI18N_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(HBDOC_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************
{$(HBMK_DIR)}.c{$(OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $<
#*******************************************************

#*******************************************************
# General *.prg --> *.obj COMPILE rules for STATIC Libraries
#*******************************************************
{$(OBJ_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(COMMON_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(PP_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(VM_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(RTL_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(MACRO_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(DEBUG_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(LANG_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(CODEPAGE_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(PCRE_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBZLIB_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBEXTERN_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(RDD_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(NULSYS_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(DBFNTX_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(DBFNSX_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(DBFCDX_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(DBFFPT_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBSIX_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(HSX_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(USRRDD_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBUDDALL_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(GTCGI_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(GTPCA_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(GTSTD_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(GTWIN_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(GTWVT_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(GTGUI_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(COMPILER_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBRUN_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSEXE) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBTEST_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSEXE) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBI18N_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSEXE) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBDOC_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSEXE) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBMK_DIR)}.prg{$(OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSEXE) -o$(OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) -Fo$(OBJ_DIR)\ $(OBJ_DIR)\$(*B).c
#*******************************************************

#*******************************************************
# General *.c --> *.obj COMPILE rules for STATIC MT Libraries
#*******************************************************
{$(VM_DIR)}.c{$(MT_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGS) $(CFLAGSMT) -Fo$(MT_OBJ_DIR)\ $<
#*******************************************************

#*******************************************************
# General *.prg --> *.obj COMPILE rules for STATIC MT Libraries
#*******************************************************
{$(VM_DIR)}.prg{$(MT_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(MT_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGS) $(CFLAGSMT) -Fo$(MT_OBJ_DIR)\ $(MT_OBJ_DIR)\$(*B).c
#*******************************************************

#*******************************************************
# General *.c --> *.obj COMPILE rules for SHARED MT Libraries
#*******************************************************
{$(VM_DIR)}.c{$(MTDLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) $(CFLAGSMT) -Fo$(MTDLL_OBJ_DIR)\ $<
#*******************************************************

#*******************************************************
# General *.prg --> *.obj COMPILE rules for SHARED MT Libraries
#*******************************************************
{$(VM_DIR)}.prg{$(MTDLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(MTDLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) $(CFLAGSMT) -Fo$(MTDLL_OBJ_DIR)\ $(MTDLL_OBJ_DIR)\$(*B).c
#*******************************************************

#*******************************************************
# General *.c --> *.obj COMPILE rules for SHARED Libraries
#*******************************************************
{$(DLL_OBJ_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(MAIN_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(COMMON_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(COMPILER_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(PP_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(VM_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(RTL_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(MACRO_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(DEBUG_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(LANG_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(CODEPAGE_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(PCRE_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(HBZLIB_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(HBEXTERN_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(RDD_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(NULSYS_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(DBFNTX_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(DBFNSX_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(DBFCDX_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(DBFFPT_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(HBSIX_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(HSX_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(USRRDD_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(HBUDDALL_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(GTCGI_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(GTPCA_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(GTSTD_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(GTWIN_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(GTWVT_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(GTGUI_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************

#*******************************************************
# General *.c --> *.obj COMPILE rules for EXECUTABLES,
# which use Harbour SHARED Library compiled as DLL
#*******************************************************
#{$(COMPILER_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
#    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(HBRUN_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(HBTEST_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(HBI18N_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(HBDOC_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************
{$(HBMK_DIR)}.c{$(DLL_OBJ_DIR)}$(OBJEXT)::
    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $<
#*******************************************************

#*******************************************************
# General *.prg --> *.obj COMPILE rules for SHARED Libraries
#*******************************************************
{$(DLL_OBJ_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(COMMON_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(PP_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(VM_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(RTL_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(MACRO_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(DEBUG_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(LANG_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(PCRE_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBZLIB_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBEXTERN_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(CODEPAGE_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(RDD_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(NULSYS_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(DBFNTX_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(DBFNSX_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(DBFCDX_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(DBFFPT_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBSIX_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(HSX_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(USRRDD_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBUDDALL_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(GTCGI_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(GTPCA_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(GTSTD_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(GTWIN_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(GTWVT_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(GTGUI_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CLIBFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************

#*******************************************************
# General *.prg --> *.obj COMPILE rules for EXECUTABLES,
# which use Harbour SHARED Library compiled as DLL
#*******************************************************
#{$(COMPILER_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
#    $(HB) $(HARBOURFLAGSLIB) -o$(DLL_OBJ_DIR)\ $<
#    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBRUN_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSEXE) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBTEST_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSEXE) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBI18N_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSEXE) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBDOC_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSEXE) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#*******************************************************
{$(HBMK_DIR)}.prg{$(DLL_OBJ_DIR)}$(OBJEXT):
    $(HB) $(HARBOURFLAGSEXE) -o$(DLL_OBJ_DIR)\ $<
    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $(DLL_OBJ_DIR)\$(*B).c
#**********************************************************

#**********************************************************
# TARGET dependencies
#**********************************************************

all : $(HB_DEST_DIRS) $(HB_BUILD_TARGETS)

#**********************************************************
# Helper targets - disabled for MSVC
#**********************************************************

#BasicLibs : $(COMMON_LIB) $(COMPILER_LIB) $(PP_LIB)
#BasicExes : $(HARBOUR_EXE)
#StdLibs   : $(STANDARD_STATIC_HBLIBS)

#**********************************************************

$(HB_DEST_DIRS) $(HB_BIN_INSTALL) $(HB_LIB_INSTALL) $(HB_INC_INSTALL):
    @if not exist $@\nul mkdir $@

#**********************************************************
# LIBRARY Targets BUILD rules
#**********************************************************
$(HBMAINSTD_LIB): $(HBMAINSTD_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(HBMAINWIN_LIB): $(HBMAINWIN_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(COMMON_LIB)   : $(COMMON_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(PP_LIB)       : $(PP_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(COMPILER_LIB) : $(COMPILER_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(VM_LIB)       : $(VM_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(VMMT_LIB)     : $(VMMT_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(RTL_LIB)      : $(RTL_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(MACRO_LIB)    : $(MACRO_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(DEBUG_LIB)    : $(DEBUG_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(LANG_LIB)     : $(LANG_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(CODEPAGE_LIB) : $(CODEPAGE_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(PCRE_LIB)     : $(PCRE_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(HBZLIB_LIB)   : $(HBZLIB_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(HBEXTERN_LIB) : $(HBEXTERN_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(RDD_LIB)      : $(RDD_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(NULSYS_LIB)   : $(NULSYS_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(DBFNTX_LIB)   : $(DBFNTX_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(DBFNSX_LIB)   : $(DBFNSX_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(DBFCDX_LIB)   : $(DBFCDX_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(DBFFPT_LIB)   : $(DBFFPT_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(HBSIX_LIB)    : $(HBSIX_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(HSX_LIB)      : $(HSX_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(USRRDD_LIB)   : $(USRRDD_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(HBUDDALL_LIB) : $(HBUDDALL_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(GTCGI_LIB)    : $(GTCGI_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(GTDOS_LIB)    : $(GTDOS_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(GTPCA_LIB)    : $(GTPCA_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(GTSTD_LIB)    : $(GTSTD_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(GTWIN_LIB)    : $(GTWIN_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(GTWVT_LIB)    : $(GTWVT_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************
$(GTGUI_LIB)    : $(GTGUI_LIB_OBJS)
    $(MKLIB) $(ARFLAGS) /out:$@ $**
#**********************************************************

#**********************************************************
# EXECUTABLE Targets
#**********************************************************

#**********************************************************
# HARBOUR build rule
#**********************************************************
$(HARBOUR_EXE) : $(HARBOUR_EXE_OBJS)
    @if exist "$(HARBOUR_EXE)" $(DEL) "$(HARBOUR_EXE)" > nul
    $(LINKER) @<<
$(LDFLAGS)
/out:$(HARBOUR_EXE)
$(**: = ^
)
$(COMMON_LIB)
$(COMPILER_LIB)
$(PP_LIB)
$(STANDARD_SYSLIBS)
<<$(HB_KEEPSTATE)
#**********************************************************
# HBPP build rule
#**********************************************************
$(HBPP_EXE) : $(HBPP_EXE_OBJS)
    @if exist "$(HBPP_EXE)" $(DEL) "$(HBPP_EXE)" > nul
    $(LINKER) @<<
$(LDFLAGS)
/out:$(HBPP_EXE)
$(**: = ^
)
$(COMMON_LIB)
$(STANDARD_SYSLIBS)
<<$(HB_KEEPSTATE)
#**********************************************************
# HBRUN build rule
#**********************************************************
$(HBRUN_EXE)  : $(HBRUN_EXE_OBJS)
    @if exist "$(HBRUN_EXE)" $(DEL) "$(HBRUN_EXE)" > nul
    $(LINKER) @<<
$(LDFLAGS)
/out:$(HBRUN_EXE)
$(**: = ^
)
$(STANDARD_STATIC_HBLIBS)
$(STANDARD_SYSLIBS)
<<$(HB_KEEPSTATE)
#**********************************************************
# HBTEST build rule
#**********************************************************
$(HBTEST_EXE) : $(HBTEST_EXE_OBJS)
    @if exist "$(HBTEST_EXE)" $(DEL) "$(HBTEST_EXE)" > nul
    $(LINKER) @<<
$(LDFLAGS)
/out:$(HBTEST_EXE)
$(**: = ^
)
$(STANDARD_STATIC_HBLIBS)
$(STANDARD_SYSLIBS)
<<$(HB_KEEPSTATE)
#**********************************************************
# HBI18N build rule
#**********************************************************
$(HBI18N_EXE) : $(HBI18N_EXE_OBJS)
    @if exist "$(HBI18N_EXE)" $(DEL) "$(HBI18N_EXE)" > nul
    $(LINKER) @<<
$(LDFLAGS)
/out:$(HBI18N_EXE)
$(**: = ^
)
$(MINIMAL_STATIC_HBLIBS)
$(STANDARD_SYSLIBS)
<<$(HB_KEEPSTATE)
#**********************************************************
# HBDOC build rule
#**********************************************************
$(HBDOC_EXE)  : $(HBDOC_EXE_OBJS)
    @if exist "$(HBDOC_EXE)" $(DEL) "$(HBDOC_EXE)" > nul
    $(LINKER) @<<
$(LDFLAGS)
/out:$(HBDOC_EXE)
$(**: = ^
)
$(MINIMAL_STATIC_HBLIBS)
$(HBDOC_LIBS)
$(STANDARD_SYSLIBS)
<<$(HB_KEEPSTATE)
#**********************************************************
# HBMK build rule
#**********************************************************
$(HBMK_EXE) : $(HBMK_EXE_OBJS)
    @if exist "$(HBMK_EXE)" $(DEL) "$(HBMK_EXE)" > nul
    $(LINKER) @<<
$(LDFLAGS)
/out:$(HBMK_EXE)
$(**: = ^
)
$(MINIMAL_STATIC_HBLIBS)
$(STANDARD_SYSLIBS)
<<$(HB_KEEPSTATE)
#**********************************************************

#**********************************************************
# DLL Targets
#**********************************************************
$(HARBOUR_DLL) : $(HB) $(DLL_OBJS)
    $(LINKER) @<<
$(LDFLAGSDLL) /out:$(@)
/implib:$(@:.dll=.lib)
$(DLL_OBJS: = ^
)
$(STANDARD_SYSLIBS)
<<$(HB_KEEPSTATE)
#**********************************************************
$(HARBOURMT_DLL) : $(HB) $(MTDLL_OBJS)
    $(LINKER) @<<
$(LDFLAGSDLL) /out:$(@)
/implib:$(@:.dll=.lib)
$(MTDLL_OBJS: = ^
)
$(STANDARD_SYSLIBS)
<<$(HB_KEEPSTATE)
#**********************************************************
# DLL EXECUTABLE Targets
#**********************************************************
HBTESTDLL_OBJS = $(DLL_OBJ_DIR)\mainstd$(OBJEXT) $(HBTEST_EXE_OBJS:obj\vc=obj\vc\dll)
$(HBTESTDLL_EXE) : $(HARBOUR_DLL) $(HBTESTDLL_OBJS)
    $(LINKER) @<<
$(LDFLAGS)
/out:$(HBTESTDLL_EXE)
$(HBTESTDLL_OBJS: = ^
)
$(HARBOUR_DLL:.dll=.lib)
$(COMMON_LIB)
<<$(HB_KEEPSTATE)
#**********************************************************
HBRUNDLL_OBJS = $(DLL_OBJ_DIR)\mainstd$(OBJEXT) $(HBRUN_EXE_OBJS:obj\vc=obj\vc\dll)
$(HBRUNDLL_EXE) : $(HARBOUR_DLL) $(HBRUNDLL_OBJS)
    $(LINKER) @<<
$(LDFLAGS)
/out:$(HBRUNDLL_EXE)
$(HBRUNDLL_OBJS: = ^
)
$(HARBOUR_DLL:.dll=.lib)
$(COMPILER_LIB) $(PP_LIB) $(COMMON_LIB)
<<$(HB_KEEPSTATE)
#----------------------------------------------------------
$(DLL_OBJ_DIR)\mainstd$(OBJEXT) : $(VM_DIR)\mainstd.c
    $(CC) $(CEXEFLAGSDLL) -Fo$(DLL_OBJ_DIR)\ $**
#**********************************************************

#**********************************************************
# EXTRA Object's DEPENDENCIES
#**********************************************************

# Generated by an intermediate utility hbpp.exe
# built at the initial phase of build process
$(OBJ_DIR)\pptable.obj     : $(OBJ_DIR)\pptable.c
$(DLL_OBJ_DIR)\pptable.obj : $(DLL_OBJ_DIR)\pptable.c

$(OBJ_DIR)\pptable.c     : $(INCLUDE_DIR)\hbstdgen.ch $(INCLUDE_DIR)\std.ch ChangeLog $(PP_DIR)\ppcore.c $(PP_DIR)\hbpp.c
    @if exist "$(OBJ_DIR)\pptable.c" $(DEL) "$(OBJ_DIR)\pptable.c" > nul
    $(HBPP) $(INCLUDE_DIR)/hbstdgen.ch -o$(OBJ_DIR)/pptable.c -q -cChangeLog -v$(INCLUDE_DIR)/hbverbld.h

$(DLL_OBJ_DIR)\pptable.c : $(INCLUDE_DIR)\hbstdgen.ch $(INCLUDE_DIR)\std.ch ChangeLog $(PP_DIR)\ppcore.c $(PP_DIR)\hbpp.c
    @if exist "$(DLL_OBJ_DIR)\pptable.c" $(DEL) "$(DLL_OBJ_DIR)\pptable.c" > nul
    $(HBPP) $(INCLUDE_DIR)/hbstdgen.ch -o$(DLL_OBJ_DIR)/pptable.c -q -cChangeLog -v$(INCLUDE_DIR)/hbverbld.h

#**********************************************************

!if "$(HB_REBUILD_PARSER)" == "yes"

$(OBJ_DIR)\harboury.c : $(COMPILER_DIR)\harbour.y
    bison --no-line -d $** -o$@

$(OBJ_DIR)\macroy.c : $(MACRO_DIR)\macro.y
    bison --no-line -d $** -o$@

$(DLL_OBJ_DIR)\harboury.c : $(COMPILER_DIR)\harbour.y
    bison --no-line -d $** -o$@

$(DLL_OBJ_DIR)\macroy.c : $(MACRO_DIR)\macro.y
    bison --no-line -d $** -o$@

!else

$(OBJ_DIR)\harboury.c : $(COMPILER_DIR)\harbour.yyc
    copy /A $** $@
    copy /A $(**:.yyc=.yyh) $(@:.c=.h)

$(OBJ_DIR)\macroy.c : $(MACRO_DIR)\macro.yyc
    copy /A $** $@
    copy /A $(**:.yyc=.yyh) $(@:.c=.h)

$(DLL_OBJ_DIR)\harboury.c : $(COMPILER_DIR)\harbour.yyc
    copy /A $** $@
    copy /A $(**:.yyc=.yyh) $(@:.c=.h)

$(DLL_OBJ_DIR)\macroy.c : $(MACRO_DIR)\macro.yyc
    copy /A $** $@
    copy /A $(**:.yyc=.yyh) $(@:.c=.h)

!endif

$(OBJ_DIR)\harboury.obj : $(OBJ_DIR)\harboury.c
$(OBJ_DIR)\macroy.obj   : $(OBJ_DIR)\macroy.c

$(DLL_OBJ_DIR)\harboury.obj : $(DLL_OBJ_DIR)\harboury.c
$(DLL_OBJ_DIR)\macroy.obj   : $(DLL_OBJ_DIR)\macroy.c

#**********************************************************


#**********************************************************
# CLEAN rules
#**********************************************************

clean: doClean
Clean: doClean
CLEAN: doClean

doClean:
    -if exist *.idb                     $(DEL) *.idb                     > nul
    -if exist *.pch                     $(DEL) *.pch                     > nul
    -if exist *.pdb                     $(DEL) *.pdb                     > nul
    -if exist $(BIN_DIR)\*.exe          $(DEL) $(BIN_DIR)\*.exe          > nul
    -if exist $(BIN_DIR)\*.pdb          $(DEL) $(BIN_DIR)\*.pdb          > nul
    -if exist $(BIN_DIR)\*.ilk          $(DEL) $(BIN_DIR)\*.ilk          > nul
    -if exist $(BIN_DIR)\*.map          $(DEL) $(BIN_DIR)\*.map          > nul
    -if exist $(BIN_DIR)\*.dll          $(DEL) $(BIN_DIR)\*.dll          > nul
    -if exist $(BIN_DIR)\*.lib          $(DEL) $(BIN_DIR)\*.lib          > nul
    -if exist $(BIN_DIR)\*.exp          $(DEL) $(BIN_DIR)\*.exp          > nul
    -if exist $(LIB_DIR)\*.lib          $(DEL) $(LIB_DIR)\*.lib          > nul
    -if exist $(OBJ_DIR)\*.obj          $(DEL) $(OBJ_DIR)\*.obj          > nul
    -if exist $(OBJ_DIR)\*.c            $(DEL) $(OBJ_DIR)\*.c            > nul
    -if exist $(OBJ_DIR)\*.h            $(DEL) $(OBJ_DIR)\*.h            > nul
    -if exist $(OBJ_DIR)\*.pch          $(DEL) $(OBJ_DIR)\*.pch          > nul
    -if exist $(DLL_OBJ_DIR)\*.obj      $(DEL) $(DLL_OBJ_DIR)\*.obj      > nul
    -if exist $(DLL_OBJ_DIR)\*.c        $(DEL) $(DLL_OBJ_DIR)\*.c        > nul
    -if exist $(DLL_OBJ_DIR)\*.h        $(DEL) $(DLL_OBJ_DIR)\*.h        > nul
    -if exist $(MT_OBJ_DIR)\*.obj       $(DEL) $(MT_OBJ_DIR)\*.obj       > nul
    -if exist $(MT_OBJ_DIR)\*.c         $(DEL) $(MT_OBJ_DIR)\*.c         > nul
    -if exist $(MT_OBJ_DIR)\*.h         $(DEL) $(MT_OBJ_DIR)\*.h         > nul
    -if exist $(MTDLL_OBJ_DIR)\*.obj    $(DEL) $(MTDLL_OBJ_DIR)\*.obj    > nul
    -if exist $(MTDLL_OBJ_DIR)\*.c      $(DEL) $(MTDLL_OBJ_DIR)\*.c      > nul
    -if exist $(MTDLL_OBJ_DIR)\*.h      $(DEL) $(MTDLL_OBJ_DIR)\*.h      > nul
    -if exist $(INCLUDE_DIR)\hbverbld.h $(DEL) $(INCLUDE_DIR)\hbverbld.h > nul
    -if exist inst_$(HB_CC_NAME).log    $(DEL) inst_$(HB_CC_NAME).log    > nul
    -if exist bin\*.exe                 $(DEL) bin\*.exe                 > nul
    -if exist bin\*.dll                 $(DEL) bin\*.dll                 > nul
    -if exist lib\*.lib                 $(DEL) lib\*.lib                 > nul

#**********************************************************
# INSTALL rules
#**********************************************************

install : doInstall
Install : doInstall
INSTALL : doInstall

doInstall: $(HB_BIN_INSTALL) $(HB_LIB_INSTALL) $(HB_INC_INSTALL)
    -if exist $(HB_BIN_INSTALL)\nul if exist $(BIN_DIR)\*.exe copy /B $(BIN_DIR)\*.exe $(HB_BIN_INSTALL) >  inst_$(HB_CC_NAME).log
    -if exist $(HB_BIN_INSTALL)\nul if exist $(BIN_DIR)\*.dll copy /B $(BIN_DIR)\*.dll $(HB_BIN_INSTALL) >> inst_$(HB_CC_NAME).log
    -if exist $(HB_LIB_INSTALL)\nul if exist $(BIN_DIR)\*.lib copy /B $(BIN_DIR)\*.lib $(HB_LIB_INSTALL) >> inst_$(HB_CC_NAME).log
    -if exist $(HB_LIB_INSTALL)\nul if exist $(LIB_DIR)\*.lib copy /B $(LIB_DIR)\*.lib $(HB_LIB_INSTALL) >> inst_$(HB_CC_NAME).log
!if "$(HB_INSTALL_PREFIX)" != "."
    -if exist $(HB_BIN_INSTALL)\nul copy /B bin\hbmk.bat         $(HB_BIN_INSTALL) >> inst_$(HB_CC_NAME).log
    -if exist $(HB_INC_INSTALL)\nul copy /B $(INCLUDE_DIR)\*.api $(HB_INC_INSTALL) >> inst_$(HB_CC_NAME).log
    -if exist $(HB_INC_INSTALL)\nul copy /B $(INCLUDE_DIR)\*.ch  $(HB_INC_INSTALL) >> inst_$(HB_CC_NAME).log
    -if exist $(HB_INC_INSTALL)\nul copy /B $(INCLUDE_DIR)\*.h   $(HB_INC_INSTALL) >> inst_$(HB_CC_NAME).log
!endif

#**********************************************************
