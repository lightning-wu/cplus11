# Copyright (c) 2014 Baidu.com, Inc. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file. See the AUTHORS file for names of contributors.


#-----------------------------------------------
# Uncomment exactly one of the lines labelled (A), (B), and (C) below
# to switch between compilation modes.
#
OPT ?= -g -O2        # (A) Production use (optimized mode)
# OPT ?= -g2      # (B) Debug mode, w/ full line-level debugging symbols
# OPT ?= -O2 -g2  # (C) Profiling mode: opt, but w/debugging symbols
#-----------------------------------------------

#-----------------------------------------------
# !!! Do not change the following lines !!!
#-----------------------------------------------


CXX=g++
INCPATH=-I. 
CXXFLAGS += $(OPT) -std=c++11 -pipe -W -Wall -fPIC -D_GNU_SOURCE -D__STDC_LIMIT_MACROS $(INCPATH)

LIBRARY=
LDFLAGS=

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    LDFLAGS += -lrt
else
    ifeq ($(UNAME_S),Darwin)
		LDFLAGS += -undefined dynamic_lookup
    endif
endif

BIN=Main Test
DIR=src
SRC=$(wildcard $(DIR)/*.cpp)
BIN_SRC := $(addprefix $(DIR)/, $(addsuffix .cpp, $(BIN)))
COMMON_SRC := $(filter-out $(BIN_SRC), $(SRC))
COMMON_OBJ=$(patsubst %.cpp,%.o,$(COMMON_SRC))


all: check_depends $(BIN) build

.PHONY: check_depends clean

check_depends:
	@echo "no depends"

build:
	mkdir -p build bin log
	cp -r $(BIN) bin/
	cp -r bin build/

clean:
	@rm -rf build $(BIN) $(DIR)/*.o

remake: clean all

Main: $(COMMON_OBJ) $(DIR)/Main.o
	$(CXX) $^ -o $@ $(LIBRARY) $(LDFLAGS)

Test: $(COMMON_OBJ) $(DIR)/Test.o
	$(CXX) $^ -o $@ $(LIBRARY) $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

