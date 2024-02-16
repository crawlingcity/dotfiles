# zmodload zsh/zprof
autoload -Uz compinit && compinit

[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
	rbenv
  dotenv
  zsh-overmind-autocomplete
)

# the source zone
[ -s ~/.p10k.zsh ] && source ~/.p10k.zsh
[ -s ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -s ~/.exports_and_aliases ] && source ~/.exports_and_aliases
[ -s ~/.functions ] && source ~/.functions
[ -s ~/.exports ] && source ~/.exports
[ -s $HOME/.oh-my-zsh/oh-my-zsh.sh ] && source $HOME/.oh-my-zsh/oh-my-zsh.sh
[ -s $SHELLZILLA_PATH/helper.sh ] && source $SHELLZILLA_PATH/helper.sh
[ -s $USER_SHELLFILE ] && source $USER_SHELLFILE
[ -s ~/homelab/scripts/homelab.sh ] && source ~/homelab/scripts/homelab.sh
[ -s ~/work/deployer/deployer.sh ] && source ~/work/deployer/deployer.sh
[ -s "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

load_remote >/dev/null 2>&1

ulimit -n 10240
# load completions
eval "$(op completion zsh)"; compdef _op op
autoload -U +X bashcompinit && bashcompinit
eval "$(zoxide init zsh)"
complete -o nospace -C /opt/homebrew/bin/terraform terraform
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

bindkey '^[[1;3D' backward-word      # alt-left
bindkey '^[[1;3C' forward-word       # alt-right
bindkey '\e[H' beginning-of-line     # home
bindkey '\e[F' end-of-line           # end
bindkey '^[[1;9D' beginning-of-line  # super-left
bindkey '^[[1;9C' end-of-line        # super-left
eval "$(atuin init zsh)"
