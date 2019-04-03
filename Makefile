location = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
thisfile := $(location)


# $@       the file name of the target
# $<       the name of the first prerequisite (i.e., dependency)
# $^       the names of all prerequisites (i.e., dependencies)
# $(@D)    the directory part of the target
# $(@F)    the file part of the target
# $(<D)    the directory part of the first prerequisite (i.e., dependency)
# $(<F)    the file part of the first prerequisite (i.e., dependency)

QUIET         = @
dotfiles-log    := ./dotfiles-update.log
update-host     = tsp18-base

hostname      := $(shell hostname -s)
rsync-opts    :=-avp
excl-git      := --exclude=".git/"
excl-node     := --exclude="node_modules"
excl-archive  := --exclude="*gz,*zip"
del-after     := --delete-after
delete        := --delete


.PHONY: help
## help  --  use update-host ENV variable to update remote host:
help : ${thisfile}
	@sed -n 's/^##//p' $<


## all               : Send all dotfiles to update-host
.PHONY: all
all: sync-completed

.PHONY: ${update-host}
${update-host}:
	${QUIET}echo "### $(date) --> Updating dotfiles on ${update-host}  ***"
	${QUIET}rsync ${rsync-opts} config/ atearoot@${update-host}:

.PHONY: localhost
localhost:
	${QUIET}echo "### $(date) --> Updating dotfiles on localhost  ***"
	${QUIET}rsync ${rsync-opts} config/ ${HOME}/

sync-completed: ${update-host} localhost
	${QUIET}echo "*** $(date) --> Updated dotfiles to $(update-host) & $(hostname)  ***"
