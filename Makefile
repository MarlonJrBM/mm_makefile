###################################
# EDIT BELOW VARIABLES WITH YOUR
# PROJECT NEEDS
###################################

#Compiler and basic compilation flags (like warnings)
CXX = g++
CXXFLAGS = -Wall -Wextra

#Folder where binary file will reside.
#Leave with . for current folder
BIN_DIR = .
_BIN = myProgram

#Folder where source files reside. Must exist.
#Leave . for current folder
SRC_DIR = src
_SRC = sample.cc sugar.cc 

#Folder where object files will reside. 
#Will be created if it doesn't exist.
#Leave . for current folder
OBJ_DIR = OBJ

#Folder where include files reside. Must preprend every folder with -I.
INCLUDES = -Iinclude -I. 

#Shared libraries to be included in compilation, must preprend with -l.
LIBS = -lpthread

#Folder where to find shared libraries, must prepend with -L.
LDFLAGS = -Llib/

#Debugging option. Leave 1 to create debugging symbols.
#Leave as 0 to compile with optimization. Defaults to 0.
DEBUG ?= 0

##########################################
# DEFAULT VARIABLES:  most of the time
# you won't need to modify them.
##########################################


BIN = $(patsubst %, $(BIN_DIR)/%, $(_BIN))

SRC = $(patsubst %, $(SRC_DIR)/%, $(_SRC))

_OBJ = $(_SRC:.cc=.o)
OBJ = $(patsubst %, $(OBJ_DIR)/%, $(_OBJ))

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
	@echo GO SUGAR!

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
	makedepend -Y -f $(DEPFILE)  -- $(INCLUDES) -- $(SRC) > /dev/null 2> /dev/null

sinclude $(DEPFILE)
