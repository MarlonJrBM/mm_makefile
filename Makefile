CXX = g++
CXXFLAGS = -Wall 
BIN = myProgram 

#Folder where source files reside. Must exist.
SRC_DIR = src
_SRC = sample.cc 
SRC = $(patsubst %,$(SRC_DIR)/%, $(_SRC))

#Folder where object files will reside. 
#Will be created if it doesn't exist.
OBJ_DIR = OBJ
_OBJ = $(_SRC:.cc=.o)
OBJ = $(patsubst %, $(OBJ_DIR)/%, $(_OBJ))

INCLUDES = -Iinclude -I.  
LIBS = 
LDFLAGS = -Llib/

DEPFILE = .deps

DEBUG ?= 0

ifeq ($(DEBUG),1)
	CXXFLAGS += -g
else
	CXXFLAGS += -O2
endif

$(BIN): $(OBJ_DIR) $(OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJ) $(LIBS) $(LDFLAGS)
	@echo Success

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cc
	$(CXX) $(CXXFLAGS) -o $@ -c $< $(INCLUDES)

run: $(BIN)
	./$(BIN)

$(OBJ_DIR):
	-mkdir -p $(OBJ_DIR)

.PHONY: cleani depend

clean:
	rm -rf $(OBJ) *~ $(BIN)

#puts dependency rules in external file
depend: $(SRC)
	touch $(DEPFILE)
	makedepend -Y -f $(DEPFILE)  -- $(INCLUDES) -- $(SRC) > /dev/null 2> /dev/null

sinclude $(DEPFILE)
