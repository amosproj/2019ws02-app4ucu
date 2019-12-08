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
DOWNLOAD_SUCCESS = downloaded
SYS_TARGET_FILE  = AURIX_Target.tlc

#---------------------- Tokens expanded by make_rtw ----------------------------
#
# The following tokens, when wrapped with "|>" and "|<" are expanded by the
# Real-Time Workshop build procedure.
#
#  MODEL_NAME      - Name of the Simulink block diagram
#  MODEL_MODULES   - Any additional generated source modules
#  MAKEFILE_NAME   - Name of makefile created from template makefile <model>.mk
#  MATLAB_ROOT     - Path to were MATLAB is installed.
#  S_FUNCTIONS     - List of additional S-function modules.
#  S_FUNCTIONS_LIB - List of S-functions libraries to link. 
#  NUMST           - Number of sample times
#  TID01EQ         - yes (1) or no (0): Are sampling rates of continuous task
#                    (tid=0) and 1st discrete task equal.
#  COMPUTER        - Computer type. See the MATLAB computer command.
#  BUILDARGS       - Options passed in at the command line.
#  MULTITASKING    - yes (1) or no (0): Is solver mode multitasking
#  INTEGER_CODE    - yes (1) or no (0): Is generated code purely integer
#  MAT_FILE        - yes (1) or no (0): Should mat file logging be done,
#                    if 0, the generated code runs indefinitely
#  CCP_AKTIV       - yes (1) or no (0): ist ccp aktiv oder nicht

MODEL           = AMOS
MODULES         = 
MAKEFILE        = Libs.mk
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
ROOT_FSW_DIR    = $(CURDIR)\Appl
ROOT_BSW_DIR    = $(CURDIR)
MAKECMD         = make -s

export PATH:=$(PATH);$(ROOT_BSW_DIR)/Bsw/util/gnu

# ----------------------------------------------------------------------------
# Directories ; Current directory = BSW
# ----------------------------------------------------------------------------
# FSW
SRC_DIR_FSW     := $(ROOT_FSW_DIR)
OUT_DIR         := $(ROOT_BSW_DIR)/output
SOURCE_GEN_DIR  := $(ROOT_FSW_DIR)/source_gen
BIN_DIR         := $(OUT_DIR)
# BSW
SRC_DIR_BSW     := $(ROOT_BSW_DIR)/Bsw
MAKE_DIR        := $(ROOT_BSW_DIR)/Bsw/make
SCRIPT_DIR      := $(MAKE_DIR)
TOOL_DIR        := $(ROOT_BSW_DIR)/Bsw/util
TMP_DIR         := $(ROOT_BSW_DIR)/tmp
LIB_BSW_DIR     := $(ROOT_BSW_DIR)/Bsw
TPL_DIR			    := $(ROOT_BSW_DIR)/Bsw/templates
LIB_BSW         := $(LIB_BSW_DIR)/BSW_Lib.a
#LIBS_SRC_LF     := $(TMP_DIR)/libs/Rte_Lib.a $(TMP_DIR)/libs/IOHwAb_C0_Lib.a $(TMP_DIR)/libs/Lastenfahrrad_Lib.a $(TMP_DIR)/libs/Bremse_Lib.a $(TMP_DIR)/libs/Lenkung_Lib.a 
LIBS_SRC_LF     := $(wildcard $(TMP_DIR)/libs/*.a)
DEVENV_DIR	    := $(ROOT_BSW_DIR)/../../27_SW_DevEnv


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
MAKE      := $(TOOL_DIR)/gnu/make.exe -s -f Libs.mk
MEMUSAGE  := $(TOOL_DIR)/gnu/memusage
RM        := $(TOOL_DIR)/gnu/rm -rf
RM2       := $(TOOL_DIR)/gnu/rm
CP        := $(TOOL_DIR)/gnu/cp -ra
MV        := $(TOOL_DIR)/gnu/mv
MKDIR     := $(TOOL_DIR)/gnu/mkdir -p
PRINT     :=@$(TOOL_DIR)/gnu/printf.exe
READELF   := $(TOOL_DIR)/gnu/readelf.exe

GET_CALIB_SIZE := $(TOOL_DIR)/getVarSize.bat

RENDER-TPL := $(TOOL_DIR)/genutils/render-tpl \
			 $(GENUTILS_PLUGINS) \
			-DECU_APP_MAJOR_VERSION=1 \
			-DECU_APP_MINOR_VERSION=0 \
			-DECU_DS_MAJOR_VERSION=1 \
			-DECU_DS_MINOR_VERSION=0 \
			-DECU_SW_VERSION=$(FSW_SW_VERSION) \
      -DECU_NAME=$(ECU_NAME)

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

# ----------------------------------------------------------------------------
# set SOURCES, INCLUDES and DAT_FILES 
# ----------------------------------------------------------------------------
#* include generated source, header and dat files
SOURCES_BSW  = $(wildcard $(SRC_DIR_BSW)/Appl/*.c) $(wildcard $(SRC_DIR_BSW)/Appl/diag/*.c) $(wildcard $(SRC_DIR_BSW)/Appl/e2e/*.c)
INCLUDES_BSW = -I$(SRC_DIR_BSW)/includes -I$(SRC_DIR_BSW)/Appl/diag -I$(SRC_DIR_BSW)/Appl/e2e -I$(SRC_DIR_BSW)/Appl
OBJECTS_BSW  = $(addprefix $(TMP_DIR)/, $(notdir $(addsuffix .o, $(basename $(SOURCES_BSW)))))


#* include FSW source, header and dat files 
# include $(MAKE_DIR)/Bsw_Lib.mak


DAT_FILES_FSW += $(wildcard $(TMP_DIR)/libs/*.dat)
DAT_FILES_BSW = $(wildcard $(SRC_DIR_BSW)/*.dat) $(wildcard $(SRC_DIR_BSW)/dat/*.dat)
OBJECTS_FSW   = $(addprefix $(TMP_DIR)/, $(notdir $(addsuffix .o, $(basename $(SOURCES_FSW)))))

INCLUDES_FSW = \
	-I$(SRC_DIR_FSW)/source \
	$(sort $(addprefix -I,$(dir $(HEADER_FSW))))

# VPATH_FSW = $(dir $(SOURCES_FSW))
# VPATH_BSW = $(dir $(SOURCES_BSW)) 

INCLUDES  = $(INCLUDES_BSW) $(INCLUDES_FSW)
# SOURCES   = $(sort $(SOURCES_BSW)  $(SOURCES_FSW))
# VPATH     = $(VPATH_BSW) $(VPATH_FSW)
DAT_FILES = $(DAT_FILES_FSW) $(DAT_FILES_BSW)
# OBJECTS   = $(OBJECTS_BSW) $(OBJECTS_FSW)

CFLAGS    += $(DEFINES) -g3 -Wno-uninitialized

#MATLAB_INCLUDES =  $(MATLAB_ROOT)\simulink\include $(MATLAB_ROOT)\extern\include $(MATLAB_ROOT)\rtw\c\src $(MATLAB_ROOT)\rtw\c\src\ext_mode\common

# memory config
include $(MAKE_DIR)/mem.mak

############ MEMORY_MAPPING ##################################################
MEM_APP_FLASH_START      := 0x80080000
MEM_APP_FLASH_END_PLUS_1 := 0x801FFF00
MEM_APP_FLASH_CRC_START  := $(MEM_APP_FLASH_END_PLUS_1)

# ----------------------------------------------------------------------------
# Targets
# ----------------------------------------------------------------------------
.PHONY: all
all:
#	@$(BREMSE_MK)
#	@$(LENKUNG_MK)
	@$(MAKE) build_info  
	@$(MAKE) clean
#	@$(MAKE) configure_fsw
	@$(MAKE) app
#	@$(MAKE) a2l
	@$(MAKE) mem_usage
	@$(MAKE) build_finish
  
.PHONY: app
app: $(BIN_DIR)/$(MODEL).hex

writeable:
	@attrib -R -H ./* /s /d

# ----------------------------------------------------------------------------
# main application and .a2l files
# ----------------------------------------------------------------------------
# - extracts memory section
# - fills empty space with illegal opcode 
# - fills empty space after CRC with 0xFF
# - adds CRC32 and XOR32 checksums
# - args: $1 memory section, $2 input file, $3 output file
define add-crc
	$(SREC_CAT) $2 -motorola \
		-crop $($1_START) $($1_END_PLUS1) \
		-fill 0xFF $($1_START) $($1_CRC_ADDRESS) \
		-fill 0xF7 $($1_CRC_ADDRESS) $($1_END_PLUS1) \
		-offset -$($1_START) -o $(basename $3).bin -binary 
	$(ADD-CRC) crc32 $($1_CRC_START_OFFSET) $($1_CRC_SIZE) \
		$($1_CRC_ADDRESS_OFFSET) $(basename $3).bin $(basename $3).bin 
	$(SREC_CAT) $(basename $3).bin -binary -offset $($1_START) -o $3 -motorola  
endef

$(BIN_DIR)/$(MODEL).hex: $(TMP_DIR)/$(MODEL).hex
#	$(PRINT) "\n... copy   \n\n"
	@$(CP) $(TMP_DIR)/$(MODEL).elf $(BIN_DIR)
	@$(CP) $(TMP_DIR)/$(MODEL).s19 $(BIN_DIR)
	@$(CP) $(TMP_DIR)/$(MODEL).hex $(BIN_DIR)
	@$(CP) $(TMP_DIR)/$(MODEL).map $(BIN_DIR)
  
$(TMP_DIR)/$(MODEL).hex: $(TMP_DIR)/$(MODEL).s19 
	$(PRINT) "... GENERATING HEX FILE   \n"
	@$(SREC_CAT) $(TMP_DIR)/$(MODEL).s19 -motorola -o $(TMP_DIR)/$(MODEL).hex -intel

$(TMP_DIR)/$(MODEL).s19: $(TMP_DIR)/$(MODEL)_first.s19
	$(PRINT) "... GENERATING BIN FILES WITH CRC  \n"
	@$(call add-crc,MEM_APP_FLASH,$(TMP_DIR)/$(MODEL)_first.s19,$(TMP_DIR)/$(MODEL).s19)
  
$(TMP_DIR)/$(MODEL)_first.s19: $(TMP_DIR)/$(MODEL).elf
	$(PRINT) "... GENERATING INTERMEDIATE S19 FILE   \n"
	@$(OC) -I elf32-tricore -O srec $(TMP_DIR)/$(MODEL).elf $(TMP_DIR)/$(MODEL)_first.s19  

# ----------------------------------------------------------------------------
# LINKING
# ----------------------------------------------------------------------------  
$(TMP_DIR)/$(MODEL).elf: $(LIBS_SRC_LF)
	$(PRINT) "\n... LINKING $(notdir $@) ...\n"
	@$(AR) x $(LIB_BSW) IfxCpu_Trap.o
	@$(AR) x $(LIB_BSW) IfxCpu_CStart0.o
	@$(AR) x $(LIB_BSW) IfxCpu_CStart1.o
	@$(AR) x $(LIB_BSW) IfxCpu_CStart2.o
	@$(AR) x $(LIB_BSW) IfxCpu_Irq.o
	@$(AR) x $(LIB_BSW) IsrCoreMapping.o
	$(MV) *.o $(TMP_DIR)
    
  # call linker  
	@$(CC) \
    $(TMP_DIR)\IfxCpu_Trap.o \
    $(TMP_DIR)\IfxCpu_CStart0.o \
    $(TMP_DIR)\IfxCpu_CStart1.o \
    $(TMP_DIR)\IfxCpu_CStart2.o \
    $(TMP_DIR)\IfxCpu_Irq.o \
    $(TMP_DIR)\IsrCoreMapping.o \
	  $(LIB_BSW) $(LIBS_SRC_LF) -L$(LIB_BSW_DIR) -T$(SCRIPT_DIR)/$(LD_FILE) $(LIBS_COMPILER) $(LDFLAGS) -o $(TMP_DIR)/$(MODEL).elf
   
# ----------------------------------------------------------------------------
# object files
# ----------------------------------------------------------------------------
$(TMP_DIR)/%.o: %.c
	$(PRINT) "... compiling $(notdir $<)\n"
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

$(TMP_DIR)/%.o: %.asm
	$(PRINT) "... AS compiling $(notdir $<)\n"
	@$(AS) -o $@ $(@:.o=.src) $(ASFLAGS) $(INCLUDES)

# ----------------------------------------------------------------------------
# Build finish
# ----------------------------------------------------------------------------
build_finish:  
	$(PRINT)  "\n\n"
	$(PRINT)  "---------------------------------------\n"
	$(PRINT)  "  build finished $(NOW)\n"
	$(PRINT)  "---------------------------------------\n\n"
	$(PRINT)  "### Created"
  
# ----------------------------------------------------------------------------
# Configure
# ----------------------------------------------------------------------------
configure_fsw:
	@$(PRINT) "... CREATING DAT C-CODE FOR FSW   \n"
	@$(RENDER-TPL) $(DAT_FILES_FSW) $(TPL_DIR)/dat_config_fsw.c.tpl $(SOURCE_GEN_DIR)/dat_config_fsw.c
	@$(RENDER-TPL) $(DAT_FILES_FSW) $(TPL_DIR)/dat_config_fsw.h.tpl $(SOURCE_GEN_DIR)/dat_config_fsw.h
  
# ----------------------------------------------------------------------------
# Mem usage
# ----------------------------------------------------------------------------  
mem_usage:  
	$(PRINT) " \n"
	@$(MEMUSAGE) $(TMP_DIR)/$(MODEL).elf 
	$(PRINT)  " \n\n"
	@$(MEMUSAGE) $(LIB_BSW) $(LIBS_SRC_LF)  
	$(PRINT)  " \n\n\n\n"
  
# ----------------------------------------------------------------------------
# Build info
# ----------------------------------------------------------------------------  
build_info:  
	$(PRINT)  " \n"
	$(PRINT)  "---------------------------------------\n"
	$(PRINT)  "  Platform         : $(HW_TARGET)\n"
	$(PRINT)  "  Model            : $(MODEL)\n"
	$(PRINT)  "  Software Version : $(FSW_SW_VERSION)\n"
	$(PRINT)  "---------------------------------------\n"
	$(PRINT)  " \n"  
  
# ----------------------------------------------------------------------------
# clean
# ----------------------------------------------------------------------------
clean:
	$(PRINT) "... CLEANING \n"
	@$(MAKE) writeable
#	@$(MKDIR) $(SOURCE_GEN_DIR)
#	@$(MKDIR) $(BIN_DIR)
#	@$(MKDIR) $(TMP_DIR)
	@$(RM) $(SOURCE_GEN_DIR)/*
	@$(RM) $(BIN_DIR)/*
# @$(RM2) $(TMP_DIR)/*.o
	
	
# ----------------------------------------------------------------------------
# makes a2l files
# ----------------------------------------------------------------------------

# - args: $1 target (INCA|CANAPE), $2 dat-file(s), $3 output
define make-a2l
	$(MAKE-A2L) \
		--prefix="__dat_calibrations_rom_EM._" \
		--prefix="__dat_calibrations_rom._" \
		-DTARGET=$1 \
		$2 $(TPL_DIR)/dat.a2l.tpl \
		$(TMP_DIR)/$(MODEL).debug_info $(TMP_DIR)/$3
endef

define make-a2l-eth
	$(MAKE-A2L) \
		--prefix="__dat_calibrations_rom_EM._" \
		--prefix="__dat_calibrations_rom._" \
		-DTARGET=$1 \
		-DRTE_CAL_SIZE=$4 \
		$2 $(TPL_DIR)/dat_eth.a2l.tpl \
		$(TMP_DIR)/$(MODEL).debug_info $(TMP_DIR)/$3
endef

define make-a2l-eth-inca
    $(MAKE-A2L) \
        --prefix="__dat_calibrations_rom_EM._" \
        --prefix="__dat_calibrations_rom._" \
        --prefix="__rte_calibrations_rom._" \
        -DTARGET=$1 \
        $2 $(TPL_DIR)/dat_inca.a2l.tpl \
        $(TMP_DIR)/$(MODEL).debug_info $(TMP_DIR)/$3
endef
     

.PHONY: a2l
a2l: RTE_CAL_DATASIZE=$(shell $(GET_CALIB_SIZE) $(MODEL))
a2l:
# make .a2l files and documentation
	$(PRINT) ">>> creating ELF debug info ...\n"
	$(READELF) --debug-dump=info $(BIN_DIR)/$(MODEL).elf > $(TMP_DIR)/$(MODEL).debug_info
	$(MERGE-DAT) $(DAT_FILES) $(TMP_DIR)/all.dat
	$(PRINT) "creating debug A2L files...\n"
	$(ELF-TO-DAT) $(TMP_DIR)/$(MODEL).debug_info $(TMP_DIR)/debug.dat
	$(MERGE-DAT) --overwrite $(TMP_DIR)/debug.dat $(TMP_DIR)/all.dat $(TMP_DIR)/debug.dat
#	$(call make-a2l,CANAPE,$(TMP_DIR)/debug.dat,$(MODEL)_canape.a2l)
#	$(call make-a2l-eth,CANAPE,$(TMP_DIR)/debug.dat,$(MODEL)_canape_eth.a2l,$(RTE_CAL_DATASIZE))
	$(call make-a2l,INCA,$(TMP_DIR)/debug.dat,$(MODEL)_inca.a2l)
	$(call make-a2l-eth,INCA,$(TMP_DIR)/debug.dat,$(MODEL)_inca_eth.a2l,$(RTE_CAL_DATASIZE))
	@$(CP) $(TMP_DIR)/*.a2l $(BIN_DIR)
  
	@$(RM) $(TMP_DIR)/debug.dat	

  