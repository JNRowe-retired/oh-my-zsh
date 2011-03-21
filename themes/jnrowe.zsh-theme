autoload is-at-least
if ! is-at-least 4.3.6; then
    echo -e "\007[Warning: jnrowe theme requires at least v4.3.6 of zsh to" \
        "function correctly!!]"
    sleep 3
    return 1
fi

autoload -U add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats \
    '%F{2}%s%F{7}:%F{2}(%F{1}%b%F{2})%f '
zstyle ':vcs_info:*' enable git hg

add-zsh-hook precmd prompt_jnrowe_precmd

# As useful as the check-for-changes functionality in vcs_info is, it does make
# it difficult to have a single value display for repository status.  This is
# the stupidly lazy way of working around that.
prompt_jnrowe_precmd () {
    vcs_info

    if [ -z "${vcs_info_msg_0_}" ]; then
        _jnrowe_dir_status="%F{2}→%f"
    elif ! git diff-index --cached --quiet --ignore-submodules HEAD 2>/dev/null; then
        _jnrowe_dir_status="%F{1}▶%f"
    elif ! git diff --no-ext-diff --ignore-submodules --quiet 2>/dev/null; then
        _jnrowe_dir_status="%F{3}▶%f"
    else
        _jnrowe_dir_status="%F{2}▶%f"
    fi
}

local _jnrowe_ret_status="%(?:%{$fg_bold[green]%}Ξ:%{$fg_bold[red]%}%S↑%s%?)"

PROMPT='${_jnrowe_ret_status}%{$fg_bold[green]%}%p %{$fg_bold[yellow]%}%2~ ${vcs_info_msg_0_}${_jnrowe_dir_status}%{$reset_color%} '
