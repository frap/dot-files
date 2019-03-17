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
update-host     = localhost

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

.PHONY: config/
config/:
	echo "### $(date) --> Sending dotfiles to ${update-host}  ***" >> ${dotfiles-log}
	${QUIET}rsync ${rsync-opts} $@ atearoot@${update-host}:

sync-completed: config/
	echo "*** $(date) --> Updated dotfiles to $(update-host)  ***" >> ${dotfiles-log}
