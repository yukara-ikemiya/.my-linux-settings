# ===========================================
#
#  Lazy Makefile
#
#  Copyright 2018, Yukara Ikemiya
#
# ===========================================

PROGRAM_NAME := test

# compiler
CXX := g++ -std=c++11
CXXFLAGS := -Wall -Wextra -O3 -mavx -fopenmp -pipe

# external libraries
EXT_LIBS := -lfftw3 -lsndfile
EXT_INCLUDES := -I/home/yukara/Tools/Eigen_3.3.2/

# source directories
ROOT_DIR := .
SOURCE_DIR := $(ROOT_DIR)
HEADER_DIR := $(ROOT_DIR)

# output directories
OUT_DIR := $(ROOT_DIR)/build
PROGRAM_DIR := $(OUT_DIR)/bin
OBJ_DIR := $(OUT_DIR)/obj
DEPEND_DIR := $(OUT_DIR)/depend

# exclusion directories
EXCLUDE_DIR_FIND := \( -path $(OUT_DIR) -prune \) -o \
					\( -path $(ROOT_DIR)/.git -prune \) -o \
					\( -path $(ROOT_DIR)/visualstudio -prune \) -o

# get all source files
SOURCES := $(shell find $(SOURCE_DIR) $(EXCLUDE_DIR_FIND) \( -type f -name "*.cpp" -o -type f -name "*.c" \) -print)
HEADERS := $(shell find $(HEADER_DIR) $(EXCLUDE_DIR_FIND) \( -type f -name "*.hpp" -o -type f -name "*.h" \) -print)

# get all sub-directories
INCLUDES := $(addprefix -I,$(shell find $(ROOT_DIR) $(EXCLUDE_DIR_FIND) \( -type d \) -print)) $(EXT_INCLUDES)
LIBS := $(EXT_LIBS)

# output files
PROGRAM := $(PROGRAM_DIR)/$(PROGRAM_NAME)
SOURCE_NAMES_CPP = $(filter %.cpp, $(SOURCES))
SOURCE_NAMES_C = $(filter %.c, $(SOURCES))
OBJS := $(addprefix $(OBJ_DIR)/,$(SOURCE_NAMES_CPP:.cpp=.o)) \
		$(addprefix $(OBJ_DIR)/,$(SOURCE_NAMES_C:.c=.o)) 
DEPENDS := $(addprefix $(DEPEND_DIR)/,$(SOURCE_NAMES_CPP:.cpp=.depend)) \
		   $(addprefix $(DEPEND_DIR)/,$(SOURCE_NAMES_C:.c=.depend))


# rules
.PHONY: all
all: $(DEPENDS) $(PROGRAM)
$(PROGRAM): $(OBJS)
	@echo "\ngenerating $@"
	@mkdir -p $(PROGRAM_DIR)
	$(CXX) $(CXXFLAGS) $^ -o $(PROGRAM) $(LIBS)

$(DEPEND_DIR)/%.depend: %.cpp $(HEADERS)
	@echo "\ngenerating $@"
	@if [ ! -e `dirname $@` ]; then mkdir -p `dirname $@`; fi
	@$(CXX) $(CXXFLAGS) $(INCLUDES) -MM $< > $@ $(LIBS) 

$(DEPEND_DIR)/%.depend: %.c $(HEADERS)
	@echo "\ngenerating $@"
	@if [ ! -e `dirname $@` ]; then mkdir -p `dirname $@`; fi
	@$(CXX) $(CXXFLAGS) $(INCLUDES) -MM $< > $@ $(LIBS) 

$(OBJ_DIR)/%.o: %.cpp
	@echo "\ngenerating $@"
	@if [ ! -e `dirname $@` ]; then mkdir -p `dirname $@`; fi
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $^ -o $@ $(LIBS)

$(OBJ_DIR)/%.o: %.c
	@echo "\ngenerating $@"
	@if [ ! -e `dirname $@` ]; then mkdir -p `dirname $@`; fi
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $^ -o $@ $(LIBS) 


ifneq "$(MAKECMDGOALS)" "clean"
-include $(DEPENDS)
endif

.PHONY : clean
clean:
	$(RM) -r $(OUT_DIR)
