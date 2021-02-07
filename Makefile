#Compiler and basic compilation flags (like warnings)
CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17

#Folder where binary file will reside.
#Leave blank for current (root) folder
BIN_DIR = bin
_BIN = main

#Folder where source files reside. Must exist.
#Leave blank for current (root) folder
SRC_DIR = src
_SRC = sample.cc sugar.cc

#Folder where object files will reside. 
#Will be created if it doesn't exist.
#Leave blank for current (root) folder
OBJ_DIR = obj

#Folder where include files reside. Must preprend every folder with -I.
INCLUDES = -Iinclude -I. -I${SRC_DIR}

#Shared libraries to be included in compilation, must preprend with -l.
LIBS = 

#Folder where to find shared libraries, must prepend with -L.
LDFLAGS = 

#Debugging option. Leave 1 to create debugging symbols.
#Leave as 0 to compile with optimization. Defaults to 0.
DEBUG ?= 0

##########################################
# DEFAULT VARIABLES:  most of the time
# you won't need to modify them.
##########################################

ifneq (${BIN_DIR},)
BIN = $(patsubst %, $(BIN_DIR)/%, $(_BIN))
else
BIN = ${_BIN}
BIN_DIR = .
endif

ifneq (${SRC_DIR},)
SRC = $(patsubst %, $(SRC_DIR)/%, $(_SRC))
else
SRC = ${_SRC}
SRC_DIR = .
endif

_OBJ = $(_SRC:.cc=.o)
ifneq (${OBJ_DIR},)
OBJ = $(patsubst %, $(OBJ_DIR)/%, $(_OBJ))
else
OBJ = ${_OBJ}
OBJ_DIR = .
endif

DEPFILE = .deps

ifeq ($(DEBUG),1)
	CXXFLAGS += -g
else
	CXXFLAGS += -O2
endif


##########################################
# RULES SECTION
#########################################

#Default rule: compiles the binary file
$(BIN): $(OBJ_DIR) $(BIN_DIR) $(OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJ) $(LIBS) $(LDFLAGS)

#Constructs object files automatically
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cc
	$(CXX) $(CXXFLAGS) -o $@ -c $< $(INCLUDES)

#Executes binary file with no arguments
run: $(BIN)
	$(BIN)

$(OBJ_DIR):
	-mkdir -p $(OBJ_DIR)

$(BIN_DIR):
	-mkdir -p $(BIN_DIR)

.PHONY: clean depend

clean:
	-rm -rf $(OBJ) *~ $(BIN)

#puts dependency rules in external file
depend: $(SRC)
	touch $(DEPFILE)
	makedepend -p obj/ -Y -f $(DEPFILE)  -- $(INCLUDES) -- $(SRC) > /dev/null 2> /dev/null

sinclude $(DEPFILE)