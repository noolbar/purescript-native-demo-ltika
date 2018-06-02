# PureScript to native binary (via C++) Makefile
#
# Run 'make' or 'make release' to build an optimized release build
# Run 'make debug' to build a non-optimized build suitable for debugging
#
# You can also perform a parallel build with 'make -jN', where N is the
# number of cores to use.
#
# PCC, SRC, OUTPUT, and BIN can all be overridden with the
# command itself. For example: 'make BIN=myutil'
#
# Flags can be added to either the codegen or native build phases.
# For example: 'make PCCFLAGS=--no-tco CXXFLAGS=-DDEBUG LDFLAGS=lobjc'
#
# You can also edit the generated version of this file directly.
#
PCC    := ./purescript-native/.stack-work/dist/2672c1f3/build/pcc/pcc
SRC    := src
OUTPUT := output
BIN    := main

SPECSFLAGS = --specs=rdimon.specs # --specs=nosys.specs # --specs=rdimon.specs # --specs=nano.specs  -dumpspecs
CPUFLAGS   = -mcpu=cortex-m4 -march=armv7e-m -mthumb -msoft-float -mfloat-abi=soft
override PCCFLAGS += --comments
# override CXXFLAGS += -std=c++11 -Wno-logical-op-parentheses -Wno-missing-braces -Wmissing-field-initializers
override CXXFLAGS += $(SPECSFLAGS) $(CPUFLAGS) -std=c++11 -Wno-missing-braces -Wmissing-field-initializers # -nostdlib # -fno-use-cxa-atexit #-fno-exceptions #-nostdinc
override CFLAGS   += $(SPECSFLAGS) $(CPUFLAGS) # -nostdlib # -nostdinc # -fno-use-cxa-atexit -fno-exceptions
# override LDFLAGS  += -Tbootfile/STM32F407VGTx_FLASH.ld -mcpu=cortex-m4 -mthumb -march=armv7e-m -mfloat-abi=soft -msoft-float -Wl,--gc-sections # -nostartfiles
override LDFLAGS  += -lstdc++ -static -Tbootfile/STM32F407VGTx_FLASH.ld $(SPECSFLAGS) $(CPUFLAGS) -Wl,--gc-sections  #-nostartfiles #-nostdlib
ifeq ($(GC),yes)
  override CXXFLAGS += -DUSE_GC
  override LDFLAGS += -lgc
endif

DEBUG := "-DDEBUG -g"
RELEASE := "-O3 -flto"

INCLUDES := -I $(OUTPUT) -I bootfile
BOOTFILEINCLUDE := -I bootfile -I bootfile/STM32Cube_FW_F4_V1.21.0/Drivers/CMSIS/Device/ST/STM32F4xx/Include -I bootfile/STM32Cube_FW_F4_V1.21.0/Drivers/CMSIS/Include -I bootfile/STM32Cube_FW_F4_V1.21.0/Drivers/STM32F4xx_HAL_Driver/Inc # -I bootfile/STM32Cube_FW_F4_V1.21.0/Drivers/BSP/STM32F4-Discovery 
BIN_DIR := $(OUTPUT)/bin


PSC_PKG_BIN := psc-package
PSC_PACKAGE := ./purescript-native/.stack-work/dist/2672c1f3/build/pcc/$(PSC_PKG_BIN)

ifeq ("$(wildcard $(PSC_PACKAGE))","")
	PSC_PACKAGE := $(PSC_PKG_BIN)
endif

PACKAGE_SOURCES = $(subst \,/,$(shell $(PSC_PACKAGE) sources))
PURESCRIPT_PKGS := $(firstword $(subst /, ,$(PACKAGE_SOURCES)))

## Not all environments support globstar (** dir pattern)
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

release: codegen
	@$(MAKE) $(BIN) CXXFLAGS+=$(RELEASE)

debug: codegen
	@$(MAKE) $(BIN) CXXFLAGS+=$(DEBUG)

codegen: PURESCRIPT_PKG_SRCS=$(foreach d,$(PACKAGE_SOURCES),$(call rwildcard,$(firstword $(subst *, ,$(d))),*.purs))
codegen: PURESCRIPT_SRCS=$(call rwildcard,$(SRC)/,*.purs)

codegen: $(PURESCRIPT_PKGS)
	@$(PCC) $(PCCFLAGS) --output $(OUTPUT) $(PURESCRIPT_PKG_SRCS) $(PURESCRIPT_SRCS)
	cp --force bootfile/Main_ffi.hh output/Main/Main_ffi.hh

$(PURESCRIPT_PKGS):
	@echo "Getting packages using" $(PSC_PACKAGE) "..."
	@$(PSC_PACKAGE) update
	

SRCS := $(call rwildcard,$(OUTPUT)/,*.cc)
BOOTFILESRCS := $(call rwildcard,bootfile/,*.c)
OBJS = $(SRCS:.cc=.o) $(BOOTFILESRCS:.c=.o) bootfile/startup_stm32f407xx.o bootfile/MPU.o
DEPS = $(SRCS:.cc=.d) $(BOOTFILESRCS:.c=.d)


$(BIN): $(OBJS)
	@echo "Linking" $(BIN_DIR)/$(BIN)
	@mkdir -p $(BIN_DIR)
	@$(CXX) $^ -o $(BIN_DIR)/$@ $(LDFLAGS)

-include $(DEPS)


%.o: %.cc
	@echo "Creating" $@
	@$(CXX) $(CXXFLAGS) $(INCLUDES) $(BOOTFILEINCLUDE) -MMD -MP -c $< -o $@

%.o: %.c
	@echo "Creating" $@
	@$(CXX) $(CFLAGS) $(BOOTFILEINCLUDE) -MMD -MP -c $< -o $@

%.o: %.s
	@echo "Creating" $@
	@$(CXX) -c $< -o $@

.PHONY: all
all: release

.PHONY: clean
clean:
	@-rm -rf $(OUTPUT)

.PHONY: run
run:
	@$(BIN_DIR)/$(BIN) $(ARGS)
