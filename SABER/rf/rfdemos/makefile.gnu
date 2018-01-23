#
# Makefile to build rfdemos files from templates
# 
# Copyright 2011 The MathWorks, Inc.

# List of templates for file generation
TEMPLATE_TARGETS := Contents.m

include $(MAKE_INCLUDE_DIR)/template_rules.gnu

prebuild : $(TEMPLATE_TARGETS)

build    :