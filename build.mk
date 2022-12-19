# Paths
DEPDIR                  ?= ./.deps
STLDIR                  ?= ./stl

# Applications
OPENSCAD                ?= openscad
GIT                     ?= git

# Git
git_revision_nr         :=$(shell $(GIT) rev-parse HEAD 2> /dev/null || echo "")
git_uncommitted_changes :=$(if $(shell $(GIT) status --untracked-files=no --porcelain 2> /dev/null || echo ""),+,)
git_revision            :=$(git_revision_nr)$(git_uncommitted_changes)

# Derived paths
stl_folder_rev :=$(STLDIR)/$(git_revision)

# Targets
.PHONY: all
all: $(PARTS:%=$(STLDIR)/%.stl)

clean:
	rm -rf $(DEPDIR)
	rm -rf $(filter-out $(dir $(STLDIR)/.), $(sort $(dir $(wildcard $(STLDIR)/*/))))

cleanall:
	rm -rf $(DEPDIR)
	rm -rf $(STLDIR)

open: $(PARTS:%=%.scad)
	$(OPENSCAD) -D "GIT_REVISION=\"$(git_revision)?\"" $(PARTS:%=%.scad)

openall:
	$(OPENSCAD) -D "GIT_REVISION=\"$(git_revision)?\"" $(shell find . -type f -name '*.scad') $(shell find . -type f -name '*.inc')

ifeq ($(git_revision_nr),)
$(STLDIR)/%.stl: %.scad
$(STLDIR)/%.stl: %.scad $(DEPDIR)/%.d | $(DEPDIR) $(STLDIR)
	$(OPENSCAD) -d $(DEPDIR)/$*.d -o $(STLDIR)/$*.stl $*.scad
else
$(STLDIR)/%.stl $(stl_folder_rev)/%.stl: %.scad
$(STLDIR)/%.stl $(stl_folder_rev)/%.stl: %.scad $(DEPDIR)/%.d | $(DEPDIR) $(STLDIR)
	$(OPENSCAD) -d $(DEPDIR)/$*.d -D "GIT_REVISION=\"$(git_revision)\"" -o $(STLDIR)/$*.stl $*.scad
	mkdir -p $(stl_folder_rev)
	cp $(STLDIR)/$*.stl $(stl_folder_rev)/$*.stl
endif

$(DEPDIR) $(STLDIR): ; @mkdir -p $@

DEPFILES := $(PARTS:%=$(DEPDIR)/%.d)
$(DEPFILES):

include $(wildcard $(DEPFILES))

