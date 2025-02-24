#(C)2004-2005 SourceMM Development Team
# Makefile written by David "BAILOPAN" Anderson

HL2SDK = ../hl2sdk
SMM_ROOT = ../metamod-source

### EDIT BELOW FOR OTHER PROJECTS ###

OPT_FLAGS = -O3 -funroll-loops -s -pipe
DEBUG_FLAGS = -g -ggdb3

CPP = g++

BINARY = csbotc_mm_i486.so

OBJECTS = cvars.cpp Menu.cpp CSBotControl.cpp SharedFunctions.cpp recipientfilters.cpp BATMenu.cpp

LINK = "$(HL2SDK)/lib/linux/tier1_i486.a" -L"$(HL2SDK)/lib/linux" -lvstdlib_srv -ltier0_srv -lm -ldl -lpthread -static-libgcc -static-libstdc++

HL2PUB = $(HL2SDK)/public

INCLUDE = -I"$(HL2PUB)" -I"$(HL2PUB)/engine" -I"$(HL2PUB)/game/server" -I"$(HL2PUB)/tier0" -I"$(HL2PUB)/tier1" -I"$(HL2SDK)/game/server" -I"$(HL2SDK)/game/shared" -I"$(SMM_ROOT)/core" -I"$(SMM_ROOT)/core/sourcehook"

ifeq "$(DEBUG)" "true"
	BIN_DIR = Debug
	CFLAGS += $(DEBUG_FLAGS)
else
	BIN_DIR = Release
	LFLAGS += -O3
	CFLAGS += $(OPT_FLAGS)
endif

LFLAGS += -fPIC

CFLAGS += -fPIC -msse -fvisibility=hidden -fvisibility-inlines-hidden
CFLAGS += -DLINUX -D_LINUX -DPOSIX -D_POSIX -DNDEBUG -DSOURCE_ENGINE=SOURCE_ENGINE_CSS
CFLAGS += -Dstricmp=strcasecmp -D_stricmp=strcasecmp -D_strnicmp=strncasecmp -Dstrnicmp=strncasecmp -D_snprintf=snprintf -D_vsnprintf=vsnprintf -D_alloca=alloca -Dstrcmpi=strcasecmp

OBJ_LINUX := $(OBJECTS:%.cpp=$(BIN_DIR)/%.o)

$(BIN_DIR)/%.o: %.cpp
	$(CPP) $(INCLUDE) $(CFLAGS) -o $@ -c $<

all:
	mkdir -p $(BIN_DIR)
	$(MAKE) sourcemm

sourcemm: $(OBJ_LINUX)
	$(CPP) $(LFLAGS) $(OBJ_LINUX) $(LINK) -shared -o$(BIN_DIR)/$(BINARY)

debug:	
	$(MAKE) all DEBUG=true

default: all

clean:
	rm -rf Release/*.o
	rm -rf Release/$(BINARY)
	rm -rf Debug/*.o
	rm -rf Debug/$(BINARY)
