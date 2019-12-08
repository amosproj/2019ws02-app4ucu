# Copyright (c) 2002 IAV GmbH
#
# File    : AURIX_Target.tmf   $Revision: 1.0 $
#
# Author  : Bernd Jahrsau
#
#------------------------ Macros read by make_rtw ------------------------------
#
# The following macros are read by the Real-Time Workshop build procedure:
#
#  MAKECMD         - This is the command used to invoke the make utility
#  HOST            - What platform this template makefile is targeted for
#                    (i.e. PC or UNIX)
SHELL            = cmd
HOST             = PC
BUILD            = yes

MODULES         = 
MAKEFILE        = SWC.mk
MATLAB_ROOT     = C:\Program Files\MATLAB\R2018a
S_FUNCTIONS     = 
S_FUNCTIONS_LIB = 
NUMST           = 1
TID01EQ         = 0
COMPUTER        = PCWIN64
BUILDARGS       = 
MULTITASKING    = 0
INTEGER_CODE    = 1
MAT_FILE        = 0
ONESTEPFCN      = 1
TERMFCN         = 0
MEXEXT          = mexw64
DOWNLOAD        = 0
DATGEN          = "|>DATGEN<|"

FSW_SW_VERSION  = XINT
HW_TARGET       = DragoonPwr
ROOT_FSW_DIR    = $(CURDIR)
ROOT_BSW_DIR    = $(CURDIR)/..
MAKECMD         = make -s

export PATH:=$(PATH);$(ROOT_BSW_DIR)/Bsw/util/gnu

# ----------------------------------------------------------------------------
# Directories ; Current directory = BSW
# ----------------------------------------------------------------------------
# FSW
SRC_DIR_SWC     := $(ROOT_FSW_DIR)/$(MODEL)
INC_DIR_RTE     := $(ROOT_FSW_DIR)/rte
OUT_DIR         := $(ROOT_FSW_DIR)/output
SOURCE_GEN_DIR  := $(ROOT_FSW_DIR)/source_gen
SRC_DIR_BSW     := $(ROOT_BSW_DIR)/Bsw
MAKE_DIR        := $(ROOT_BSW_DIR)/Bsw/make
SCRIPT_DIR      := $(MAKE_DIR)
TOOL_DIR        := $(ROOT_BSW_DIR)/Bsw/util
TMP_DIR         := $(ROOT_BSW_DIR)/tmp
BIN_DIR         := $(TMP_DIR)/libs
LIB_BSW_DIR     := $(ROOT_BSW_DIR)/Bsw
DEVENV_DIR	    := $(ROOT_BSW_DIR)/../../27_SW_DevEnv
LIB_SWC         := $(BIN_DIR)/$(MODEL)_Lib.a

# ----------------------------------------------------------------------------
# macros
# ----------------------------------------------------------------------------
# set shell
export SHELL := cmd.exe
# calc date 
NOW := $(shell cmd /C date /T) $(shell cmd /C time /T)
# searching in subdirectories
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

# ----------------------------------------------------------------------------
# GNU Tools 
# ----------------------------------------------------------------------------
SREC_CAT  := $(TOOL_DIR)/srec_cat.exe -execution_start_address 0x80020000
MAKE      := $(TOOL_DIR)/gnu/make.exe -s -f SWC.mk MODEL=$(MODEL) MODEL_FOLDER=$(MODEL_FOLDER)
MEMUSAGE  := $(TOOL_DIR)/gnu/memusage
RM        := $(TOOL_DIR)/gnu/rm -rf
CP        := $(TOOL_DIR)/gnu/cp -ra
MV        := $(TOOL_DIR)/gnu/mv
MKDIR     := $(TOOL_DIR)/gnu/mkdir -p
PRINT     :=@$(TOOL_DIR)/gnu/printf.exe
READELF   := $(TOOL_DIR)/gnu/readelf.exe



include $(MAKE_DIR)/Gnuc.mak

# ----------------------------------------------------------------------------
# Python tools
# ----------------------------------------------------------------------------
ADD-CRC   := $(TOOL_DIR)/genutils/add-crc.exe
MERGE-DAT := $(TOOL_DIR)/genutils/merge-dat.exe
ELF-TO-DAT:= $(TOOL_DIR)/genutils/elf-to-dat.exe
MAKE-A2L  := $(TOOL_DIR)/genutils/make-a2l.exe

DEFINES = \
	-DECU_FSW_VERSION=$(ECU_FSW_VERSION) \
	-D$(HW_TARGET) 


INCLUDES_BSW = -I$(SRC_DIR_BSW)/includes -I$(SRC_DIR_BSW)/Appl

SOURCES_SWC_ALL    = $(call rwildcard,$(SRC_DIR_SWC)/,*.c)
SOURCES_SWC_FILTER = $(foreach f,$(SOURCES_SWC_ALL),$(if $(filter stub,$(subst /, ,$f)),,$f))
SOURCES_SWC       = $(SOURCES_SWC_FILTER)
HEADER_SWC_ALL     = $(call rwildcard,$(SRC_DIR_SWC)/,*.h))
HEADER_SWC_FILTER  = $(foreach f,$(HEADER_SWC_ALL),$(if $(filter stub,$(subst /, ,$f)),,$f))
HEADER_SWC        = $(HEADER_SWC_FILTER)

OBJECTS_SWC   = $(addprefix $(TMP_DIR)/$(MODEL)/, $(notdir $(addsuffix .o, $(basename $(SOURCES_SWC)))))


INCLUDES_SWC = $(sort $(addprefix -I,$(dir $(HEADER_SWC))))
INCLUDES_RTE = $(sort $(addprefix -I,$(dir $(call rwildcard,$(INC_DIR_RTE)/,*.h))))


VPATH_SWC = $(dir $(SOURCES_SWC))

# DAT_FILES = $(wildcard $(SRC_DIR_SWC)/*.dat)

ifeq ($(MODEL),IOHwAb_C0)
	SOURCES_BSW  = $(wildcard $(SRC_DIR_BSW)/Appl/*.c) $(wildcard $(SRC_DIR_BSW)/Appl/diag/*.c) $(wildcard $(SRC_DIR_BSW)/Appl/e2e/*.c) $(wildcard $(ROOT_FSW_DIR)/*.c)
	VPATH_BSW    = $(dir $(SOURCES_BSW))
	OBJECTS_BSW  = $(addprefix $(TMP_DIR)/, $(notdir $(addsuffix .o, $(basename $(SOURCES_BSW)))))
	INCLUDES_APPL = $(sort $(addprefix -I,$(dir $(wildcard $(ROOT_FSW_DIR)/*.h))))
endif

INCLUDES  = $(INCLUDES_BSW) $(INCLUDES_RTE) $(INCLUDES_SWC) $(INCLUDES_APPL)
VPATH     = $(VPATH_BSW) $(VPATH_SWC) $(VPATH_BSW)
OBJECTS   = $(OBJECTS_BSW) $(OBJECTS_SWC)
SOURCES   = $(sort $(SOURCES_SWC)) $(sort $(SOURCES_BSW))

CFLAGS    += $(DEFINES) -g3 -Wno-uninitialized


# ----------------------------------------------------------------------------
# Targets
# ----------------------------------------------------------------------------
.PHONY: all 
all: 
	$(PRINT) "$(SOURCES_BSW) \n"
	$(PRINT) "$(addprefix $(TMP_DIR)/, $(notdir $(addsuffix .o, $(basename $(SOURCES_BSW))))) \n"
	$(MAKE) clean
	$(MAKE) $(LIB_SWC) 


writeable:
	@attrib -R -H ./* /s /d

.PHONY: build_info 
build_info:
	$(PRINT)  "\n"
	$(PRINT)  " ---------------------------------------      \n"
	$(PRINT)  "  Command            : $(COMMAND)             \n"
	$(PRINT)  "  $(MODEL) Lib Version    : $(SWC_LIB_VERSION)     \n"
	$(PRINT)  "  Use multiple cores : $(ENABLE_MULTI_PROCESS)\n"
	$(PRINT)  " ---------------------------------------      \n"
	$(PRINT)  "\n"

$(LIB_SWC): $(OBJECTS)
	@$(MKDIR) "$(BIN_DIR)" 
	$(PRINT) "\n... BUILDING LIB $@   \n\n"
	@$(AR) -r $(ARFLAGS) $(LIB_SWC) $(OBJECTS)
#	@$(CP) $(SRC_DIR_SWC)/*.dat "$(BIN_DIR)" ||:
	@echo  ************************************************
	@echo  * $(MODEL) Library build finished $(NOW) * 
	@echo  ************************************************   

$(TMP_DIR)/%.o: %.c
	@echo compiling $(notdir $<)...
	@$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<
    
$(TMP_DIR)/$(MODEL)/%.o: %.c
	@echo compiling $(notdir $<)...
	@$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

$(TMP_DIR)/$(MODEL)/%.o: %.asm 
	@$(PRINT) "AS compiling $(notdir $<)...\n"
	@$(AS) -o $@ $(@:.o=.src) $(ASFLAGS) $(INCLUDES) 

.PHONY: clean
clean:
	@$(PRINT) "... DELETING $(MODEL) OBJECTS  \n"
	@$(MAKE) writeable
	@$(RM) "$(LIB_SWC)" ||:
	@$(RM) "$(TMP_DIR)/$(MODEL)/*.o" ||:
	@$(MKDIR) "$(TMP_DIR)/$(MODEL)"
	@$(MKDIR) "$(BIN_DIR)"