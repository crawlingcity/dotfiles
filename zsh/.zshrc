# zmodload zsh/zprof
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
  dotenv
  zsh-overmind-autocomplete
)

export SHELLZILLA_PATH="$HOME/work/shellzilla"
export OVERMIND_SOCKET="${HOME}/work/.overmind.sock"
# the source zone
[ -s ~/.p10k.zsh ] && source ~/.p10k.zsh
[ -s ~/.fzf.zsh ] && source ~/.fzf.zsh
zstyle ':omz:update' mode disabled  # don't check for updates on every start
autoload -Uz compinit
if [[ -n "${ZDOTDIR:-$HOME}/.zcompdump"(#qN.mh+24) ]]; then
  compinit
else
  compinit -C  # skip security check, use cached dump
fi
[ -s $HOME/.oh-my-zsh/oh-my-zsh.sh ] && source $HOME/.oh-my-zsh/oh-my-zsh.sh
[ -s ~/work/shellzilla/helper.sh ] && source ~/work/shellzilla/helper.sh
[ -s ~/homelab/scripts/homelab.sh ] && source ~/homelab/scripts/homelab.sh
[ -s ~/work/deployer/deployer.sh ] && source ~/work/deployer/deployer.sh
[ -s "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"
load_remote >/dev/null 2>&1
# this has to be after load_remote for noglob to work as inteded
[ -s ~/.exports_and_aliases ] && source ~/.exports_and_aliases
[ -s ~/.functions ] && source ~/.functions
[ -s ~/.exports ] && source ~/.exports
[ -s $USER_SHELLFILE ] && source $USER_SHELLFILE # depends on .exports

ulimit -n 10240
# load completions
autoload -U +X bashcompinit && bashcompinit
_op_completion_cache="${XDG_CACHE_HOME:-$HOME/.cache}/op_completion.zsh"
if [[ ! -f "$_op_completion_cache" ]]; then
  op completion zsh >| "$_op_completion_cache" && echo "compdef _op op" >> "$_op_completion_cache"
fi
source "$_op_completion_cache"
eval "$(zoxide init zsh)"
complete -o nospace -C /opt/homebrew/bin/terraform terraform

bindkey '^[[1;3D' backward-word      # alt-left
bindkey '^[[1;3C' forward-word       # alt-right
bindkey '\e[H' beginning-of-line     # home
bindkey '\e[F' end-of-line           # end
bindkey '^[[1;9D' beginning-of-line  # super-left
bindkey '^[[1;9C' end-of-line        # super-right
eval "$(atuin init zsh)"
_brew_shellenv_cache="${XDG_CACHE_HOME:-$HOME/.cache}/brew_shellenv.zsh"
if [[ ! -f "$_brew_shellenv_cache" || /opt/homebrew/bin/brew -nt "$_brew_shellenv_cache" ]]; then
  /opt/homebrew/bin/brew shellenv >| "$_brew_shellenv_cache"
fi
source "$_brew_shellenv_cache"

# bun completions
[ -s "/Users/crawling/.bun/_bun" ] && source "/Users/crawling/.bun/_bun"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# Added by Antigravity
export PATH="/Users/crawling/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
