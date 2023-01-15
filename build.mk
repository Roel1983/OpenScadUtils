PARTS                   ?=
IMAGES                  ?=

# Paths
DEPDIR                  ?= ./.deps
PARTSDIR                ?= ./parts
IMAGESDIR               ?= ./images

# Extensions
PART_SOURCE_EXTENSION       ?= .scad
PART_DESTINATION_EXTENSION  ?= .stl
IMAGE_SOURCE_EXTENSION      ?= .scad
IMAGE_DESTINATION_EXTENSION ?= .png

# Applications
OPENSCAD                ?= openscad
GIT                     ?= git
OPENSCAD_ADDITION_ARGS  ?=

# Git
git_revision_nr         :=$(shell $(GIT) rev-parse HEAD 2> /dev/null || echo "")
git_uncommitted_changes :=$(if $(shell $(GIT) status --untracked-files=no --porcelain 2> /dev/null || echo ""),+,)
git_revision            :=$(git_revision_nr)$(git_uncommitted_changes)

# Derived
ifeq ($(git_revision_nr),)
OPENSCAD_ARGS           += -D "GIT_REVISION=\"$(git_revision)\""
endif

# Targets
.PHONY: all
all:

.PHONY: all_parts
all_parts: $(PARTS:%=$(PARTSDIR)/%.stl)
all: all_parts

.PHONY: all_images
all_images: $(IMAGES:%=$(IMAGESDIR)/%.png)
all: all_images

.PHONY: clean_deps
clean_deps:
	rm -r $(DEPDIR)

.PHONY: clean_parts
clean_parts:
	rm -r $(PARTSDIR)

.PHONY: clean_images
clean_images:
	rm -r $(IMAGESDIR)

clean: clean_deps clean_parts clean_images

$(PARTSDIR)/%.stl: %$(PART_SOURCE_EXTENSION)
$(PARTSDIR)/%.stl: %$(PART_SOURCE_EXTENSION) | $(DEPDIR)/%.d
	mkdir -p $(DEPDIR)/$(dir $*)
	mkdir -p $(PARTSDIR)/$(dir $*)
	$(OPENSCAD) -d $(DEPDIR)/$*.d $(OPENSCAD_ARGS) -D "IS_PART=1" $(OPENSCAD_ADDITION_ARGS) -o $(PARTSDIR)/$*$(PART_DESTINATION_EXTENSION) $*$(PART_SOURCE_EXTENSION)

$(IMAGESDIR)/%.png: %$(IMAGE_SOURCE_EXTENSION)
$(IMAGESDIR)/%.png: %$(IMAGE_SOURCE_EXTENSION) | $(DEPDIR)/%.d
	mkdir -p $(DEPDIR)/$(dir $*)
	mkdir -p $(IMAGESDIR)/$(dir $*)
	$(OPENSCAD) -d $(DEPDIR)/$*.d $(OPENSCAD_ARGS) -D "IS_IMAGE=1" $(OPENSCAD_ADDITION_ARGS) -o $(IMAGESDIR)/$*$(IMAGE_DESTINATION_EXTENSION) $*$(IMAGE_SOURCE_EXTENSION)

DEPFILES := $(PARTS:%=$(DEPDIR)/%.d) $(IMAGES:%=$(DEPDIR)/%.d)
$(DEPFILES):
include $(wildcard $(DEPFILES))

