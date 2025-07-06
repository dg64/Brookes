#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export EDITOR="vim"

# --- setting fzf
eval "$(fzf --bash)"

export FZF_DEFAULT_COMMAND="fd --type f --color=always --exclude .git --ignore-file ~/.gitignore"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--exact --ansi"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# --- setting starship
eval "$(starship init bash)"

# --- aliases
alias ll="ls -l"
alias ls="eza --icons=always"

# --- fzf helper functions
_fzf_compgen_path() {
	fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
	fd --type d --hidden --exclude .git . "$1"
}

_fzf_comprun() {
	local command=$1
	shift
	case "$command" in
		cd)		fzf --previev 'eza --tree --color=always {} | head -200' "$@";;
		export|unset)	fzf --preview "eval 'echo \$' {}" "$@";;
		ssh)		fzf --preview "dig {}" "$@";;
		*)		fzf --preview "--preview 'bat -n --color=always --line-range :500 {}'" "$@";;
	esac
}


