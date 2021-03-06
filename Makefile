# Makefile for building mirage render

# Linker
LD = gcc

# Include directories
CXXINCS += -I./include/

# Linker flags
LDFLAGS = -Wl,--as-needed -m64

# Linker libs, lua might be -llua or -llua53 or -lluaXX, XX being your installed lua version
ifeq ($(OS), Windows_NT)
  LDLIBS = -L./lib/ -lmingw32 -lSDL2main
endif
LDLIBS += -lSDL2 -llua53 -lpthread -lstdc++ -lm -static-libgcc -static-libstdc++

# Compiler
CXX = gcc

# Compiler flags
CXXFLAGS = -std=c++11 -Wall -Wextra -m64

# Apply optimization parameters if !DEBUG
DEBUG ?= 0
ifeq ($(DEBUG), 1)
	CXXFLAGS += Og -g
else
	CXXFLAGS += -Ofast -flto
	LDFLAGS += -Ofast -flto
endif

# src & bin directories
SRCDIR = src
BINDIR = out

# Target binary
TARGET = $(BINDIR)/mirage

# CPPs, Includes & Objects
CPPS := $(wildcard $(SRCDIR)/*.cpp)
CPPS += $(wildcard $(SRCDIR)/core/*.cpp)
CPPS += $(wildcard $(SRCDIR)/math/*.cpp)
CPPS += $(wildcard $(SRCDIR)/shapes/*.cpp)
CPPS += $(wildcard $(SRCDIR)/cameras/*.cpp)
CPPS += $(wildcard $(SRCDIR)/accelerators/*.cpp)
CPPS += $(wildcard $(SRCDIR)/renderers/*.cpp)
CPPS += $(wildcard $(SRCDIR)/materials/*.cpp)
CPPS += $(wildcard $(SRCDIR)/lights/*.cpp)
INCS := $(wildcard $(SRCDIR)/*.h)
INCS += $(wildcard $(SRCDIR)/core/*.h)
INCS += $(wildcard $(SRCDIR)/math/*.h)
INCS += $(wildcard $(SRCDIR)/shapes/*.h)
INCS += $(wildcard $(SRCDIR)/cameras/*.h)
INCS += $(wildcard $(SRCDIR)/accelerators/*.h)
INCS += $(wildcard $(SRCDIR)/renderers/*.h)
INCS += $(wildcard $(SRCDIR)/materials/*.h)
INCS += $(wildcard $(SRCDIR)/lights/*.h)
OBJS := $(CPPS:$(SRCDIR)/%.cpp=$(BINDIR)/%.o)

# Build target
all: $(TARGET)

# Compile all
$(OBJS): $(BINDIR)/%.o : $(SRCDIR)/%.cpp
	@$(CXX) $(CXXFLAGS) $(CXXINCS) $^ -c $c -o $@
	@echo "Compiling done for file $@"

# Link all to executable
$(TARGET): $(OBJS)
	@$(LD) $(CXXFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@
	@echo "Linking done for file $@"

# Clean all in BINDIR
.PHONY: clean
clean:
	@$(RM) $(OBJS)
	@$(RM) $(TARGET)
	@echo "Cleanup done."

# Initialize bin directory structure
.PHONY: init
init:
	@$(MKDIR) $(BINDIR)
	@$(MKDIR) $(BINDIR)/core
	@$(MKDIR) $(BINDIR)/math
	@$(MKDIR) $(BINDIR)/shapes
	@$(MKDIR) $(BINDIR)/cameras
	@$(MKDIR) $(BINDIR)/accelerators
	@$(MKDIR) $(BINDIR)/renderers
	@$(MKDIR) $(BINDIR)/materials
	@$(MKDIR) $(BINDIR)/lights
	@echo "Initialization done."