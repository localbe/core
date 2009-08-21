#
# $Id$
#

OBJ_EXT := .obj
LIB_PREF :=
LIB_EXT := .lib

HB_DYN_COPT := -DHB_DYNLIB
OBJ_DYN_POSTFIX := _dyn

CC := cl.exe
CC_IN := -c
CC_OUT := -Fo

CPPFLAGS := -nologo -I. -I$(HB_INC_COMPILE) -Gs
CFLAGS :=
LDFLAGS :=

ifeq ($(HB_BUILD_MODE),c)
   CPPFLAGS += -TC
endif
ifeq ($(HB_BUILD_MODE),cpp)
   CPPFLAGS += -TP
endif
# Build in C++ mode by default
ifeq ($(HB_BUILD_MODE),)
   CPPFLAGS += -TP
endif

ifneq ($(HB_BUILD_WARN),no)
   CPPFLAGS += -W4 -wd4127
endif

ifneq ($(HB_BUILD_OPTIM),no)
   ifeq ($(HB_VISUALC_VER_PRE80),)
      CPPFLAGS += -Ot2b1 -EHs-c-
   else
      CPPFLAGS += -Ogt2yb1p -GX- -G6 -YX
   endif
endif

ifeq ($(HB_BUILD_DEBUG),yes)
   CPPFLAGS += -MTd -Zi
else
   CPPFLAGS += -MT
endif

# # NOTE: -GA flag should be disabled when building MT _.dlls_,
# #       as it creates bad code according to MS docs [vszakats].
# ifeq ($(HB_VISUALC_VER_PRE70),)
#    CPPFLAGS += -GA
# endif

LD := link.exe
LD_OUT := /out:

LIBPATHS := /libpath:$(LIB_DIR)
LDLIBS := $(foreach lib,$(LIBS) $(SYSLIBS),$(lib)$(LIB_EXT))

LDFLAGS += /nologo $(LIBPATHS)

AR := lib.exe
ARFLAGS :=
AR_RULE = $(AR) $(ARFLAGS) $(HB_USER_AFLAGS) /nologo /out:$(LIB_DIR)/$@ $(^F) || $(RM) $(LIB_DIR)/$@

DY := $(LD)
DFLAGS := /nologo /dll /subsystem:console
DY_OUT := $(LD_OUT)
DLIBS := $(foreach lib,$(SYSLIBS),$(lib)$(LIB_EXT))

# NOTE: The empty line directly before 'endef' HAVE TO exist!
define dyn_object
   @$(ECHO) $(ECHOQUOTE)$(file)$(ECHOQUOTE) >> __dyn__.tmp

endef
define create_dynlib
   @$(ECHO) $(ECHOQUOTE) $(DFLAGS) > __dyn__.tmp
   $(foreach file,$^,$(dyn_object))
   $(DY) $(DY_OUT)"$(subst /,$(DIRSEP),$(DYN_DIR)/$@)"$(ECHOQUOTE) @__dyn__.tmp $(HB_USER_DFLAGS) $(DLIBS)
endef

DY_RULE = $(create_dynlib)

include $(TOP)$(ROOT)config/rules.mk
