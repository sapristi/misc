# /etc/bash.bashrc
#
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.

if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi




######  aliases and variables

export EDITOR=emacs
alias pacman-download-package="pacman -Sw"
alias pacman-package-info="pacman -Si"
alias pacman-list-installed-files="pacman -Ql"
alias pacman-list-usesless-packages="pacman -Qdt"
alias pacman-clear="pacman -Rns"

##### end aliases and variables

# add completion after man
complete -cf man

#Bash history completion bound to arrow keys (down, up): 
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'


# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*|lilyterm)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
    ;;
  screen)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
    ;;
esac

# Fortune is a simple program that displays a pseudorandom message
# from a database of quotations at logon and/or logout;
# type: "pacman -S fortune-mod" to install it, then uncomment the
# following lines:

# if [ "$PS1" ]; then
#	/usr/bin/fortune
# fi

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.

# Dynamically modified variables. Do not change them!
use_color=false
# sanitize TERM:
safe_term=${TERM//[^[:alnum:]]/?}
match_lhs=""
# End of init of dynamic variables


[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
#	      	PS1=">"
	      	PS1="\[\e[0;33m\]( \[\e[1;33m\]\w \[\e[0;33m\])\[\e[1;31m\]  >\[\e[0;31m\]>\[\e[0m\] "
	else

	      	PS1="\[\e[0;34m\]( \[\e[1;34m\]\w \[\e[0;34m\])\[\e[0;36m\]  >\[\e[1;36m\]>\[\e[0m\] "
	fi

	alias ls='ls --color=auto'
	alias dir='dir --color=auto'
	alias grep='grep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we do not have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

PS2='> '
PS3='> '
PS4='+ '

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

############################# old bashrc
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
#[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
#PS2='> '
#PS3='> '
#PS4='+ '

#case ${TERM} in
#  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
#    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
                                                        
#    ;;
#  screen)
#    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
#    ;;
#esac

#[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
