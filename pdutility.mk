#
#  pdutility - Handy utility functions for Playdate development.
#
#  MIT License
#  Copyright (c) 2022 Didier Malenfant.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.
#

# -- Find out more about where this file is relative to the Makefile including it
RELATIVE_FILE_PATH := $(lastword $(MAKEFILE_LIST))
RELATIVE_DIR := $(subst /$(notdir $(RELATIVE_FILE_PATH)),,$(RELATIVE_FILE_PATH))

# -- Add us as an include search folder only if it's not already there
uniq = $(if $1,$(firstword $1) $(call uniq,$(filter-out $(firstword $1),$1)))
UINCDIR := $(call uniq, $(UINCDIR) $(RELATIVE_DIR))

# -- This is our current version number
PDUTILITY_VERSION := 0002
UDEFS := $(UDEFS) -DPDUTILITY_VERSION=$(PDUTILITY_VERSION)

# -- Add our source files.
SRC := $(SRC) \
	   $(RELATIVE_DIR)/pdutility/platform.c
