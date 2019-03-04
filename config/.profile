#!/usr/bin/env bash
# This file is loaded by many shells, including graphical ones.

export PATH="$HOME/.local/bin:$PATH"

case "$(uname -s)" in

   Darwin)
     OSTYPE="Mac"
     ;;

   Linux)
     OSTYPE="Penquin"
     ;;

   CYGWIN*|MINGW32*|MSYS*)
     OSTYPE="Crap"
     ;;

   # Add here more strings to compare
   # See correspondence table at the bottom of this answer

   *)
     OSTYPE='Wierd%'
     ;;
esac

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

if [ "OSTYPE" == "Mac" ]; then

    # Case-insensitive globbing (used in pathname expansion)
    shopt -s nocaseglob;

    # Append to the Bash history file, rather than overwriting it
    shopt -s histappend;

    # Autocorrect typos in path names when using `cd`
    shopt -s cdspell;

    # Enable some Bash 4 features when possible:
    # * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
    # * Recursive globbing, e.g. `echo **/*.txt`
    for option in autocd globstar; do
	    shopt -s "$option" 2> /dev/null;
    done;

    # Add tab completion for many Bash commands
    if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	    source "$(brew --prefix)/share/bash-completion/bash_completion";
    elif [ -f /etc/bash_completion ]; then
	    source /etc/bash_completion;
    fi;

    # Enable tab completion for `g` by marking it as an alias for `git`
    if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	    complete -o default -o nospace -F _git g;
    fi;

    # Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
    [ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

    # Add tab completion for `defaults read|write NSGlobalDomain`
    # You could just use `-g` instead, but I like being explicit
    complete -W "NSGlobalDomain" defaults;

    # Add `killall` tab completion for common apps
    complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal" killall;
    # This should be the last line of the file
    # For local changes
fi

export EDITOR="editor"
export VISUAL="$EDITOR"
export ALTERNATE_EDITOR=""

export GOPATH="$HOME/Dev/go"

# Don't make edits below this
[[ -f "~/.bash_profile.local" ]] && source "~/.bash_profile.local"
