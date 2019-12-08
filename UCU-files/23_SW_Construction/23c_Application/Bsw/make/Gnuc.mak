COMPILER_DIR := "C:/HighTec/toolchains/tricore/v4.9.3.0-infineon-1.0"

# Compiler options
CFLAGS = -DGNU -msmall-const=8 -Wall -g -O0 -std=c99 \
		-fno-common -fno-short-enums -mtc161 -fsingle-precision-constant \
        -fstrict-volatile-bitfields -fno-strict-aliasing -g -c -fmax-errors=10


        
# Assembler options
ASFLAGS = $(CFLAGS)

# Linker options
LDFLAGS = -Wl,--mcpu=tc161 -Wl,--gc-sections -nostartfiles -Wl,-Map=$(TMP_DIR)/$(MODEL).map


ARFLAGS :=



# Library configurations
# Note: There are no configurations required for including standard libraries for this build environment.
LIB_DIR_COMPILER=
LIBS_COMPILER=-lc -lgcc -lm -lg

# compiler
OC := "$(COMPILER_DIR)/bin/tricore-objcopy"
CC := "$(COMPILER_DIR)/bin/tricore-gcc"
LD := "$(COMPILER_DIR)/bin/tricore-gcc"
AR := "$(COMPILER_DIR)/bin/tricore-ar"
AS := "$(COMPILER_DIR)/bin/tricore-gcc"

# ----------------------------------------------------------------------------
# Linker File
# ----------------------------------------------------------------------------
LD_FILE := Lcf_Gnuc.lsl
