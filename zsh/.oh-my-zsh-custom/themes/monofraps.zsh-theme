R=$fg_bold[red]
G=$fg_bold[green]
M=$fg_bold[magenta]
Y=$fg_bold[yellow]
B=$fg_bold[blue]
RESET=$reset_color

function prompt_char {
	if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

PROMPT='%{$G%}%n %{$B%}%(!.%1~.%~) %_$(prompt_char)%{$reset_color%} '

local return_code="%(?.%{$G%}.%{$R%})%? ↵%{$RESET%}"
RPROMPT='${return_code} %{$M%}[$(current_branch)$(git_prompt_status)%{$M%}]%{$RESET%}'

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

ZSH_THEME_GIT_PROMPT_UNMERGED="%{$R%}*"
ZSH_THEME_GIT_PROMPT_DELETED="%{$R%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$M%}*"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$M%}*"
ZSH_THEME_GIT_PROMPT_ADDED="%{$G%}+"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$R%}⚡"
ZSH_THEME_GIT_PROMPT_DIRTY="⚡"
