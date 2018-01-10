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
LIBS := -lfftw3 -lsndfile
EXT_INCLUDES := -I/home/yukara/Tools/Eigen_3.3.2/

# directory
ROOT_DIR := .
OUT_DIR := build
SOURCE_DIR := $(ROOT_DIR)
HEADER_DIR := $(ROOT_DIR)

SOURCES := $(shell find . -name "*.cpp" -or -name "*.c")
HEADERS := $(shell find . -name "*.hpp" -or -name "*.h")

# exclude the .git directory
INCLUDES := $(addprefix -I,$(shell find $(ROOT_DIR) -path $(ROOT_DIR)/.git -prune -o -type d -print)) $(EXT_INCLUDES)

PROGRAM_DIR := $(OUT_DIR)/bin
OBJ_DIR := $(OUT_DIR)/obj
DEPEND_DIR := $(OUT_DIR)/depend

PROGRAM := $(PROGRAM_DIR)/$(PROGRAM_NAME)
SOURCE_NAMES = $(SOURCES) # $(notdir $(SOURCES))
OBJS := $(addprefix $(OBJ_DIR)/,$(SOURCE_NAMES:.cpp=.o))
DEPENDS := $(addprefix $(DEPEND_DIR)/,$(SOURCE_NAMES:.cpp=.depend))

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

$(OBJ_DIR)/%.o: %.cpp
	@echo "\ngenerating $@"
	@if [ ! -e `dirname $@` ]; then mkdir -p `dirname $@`; fi
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $^ -o $@ $(LIBS) 


ifneq "$(MAKECMDGOALS)" "clean"
-include $(DEPENDS)
endif

.PHONY : clean
clean:
	$(RM) -r $(OUT_DIR)
