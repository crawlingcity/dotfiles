# zmodload zsh/zprof
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
  dotenv
)

# macOS-only plugins
if [[ "$OSTYPE" == "darwin"* ]]; then
  plugins+=(zsh-overmind-autocomplete)
fi

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

# macOS-only: iTerm2 shell integration
if [[ "$OSTYPE" == "darwin"* ]]; then
  [ -s "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"
fi

load_remote >/dev/null 2>&1
# this has to be after load_remote for noglob to work as inteded
[ -s ~/.exports_and_aliases ] && source ~/.exports_and_aliases
[ -s ~/.functions ] && source ~/.functions
[ -s ~/.exports ] && source ~/.exports
[ -n "$USER_SHELLFILE" ] && [ -s "$USER_SHELLFILE" ] && source "$USER_SHELLFILE" # depends on .exports

ulimit -n 10240
# load completions
autoload -U +X bashcompinit && bashcompinit

# 1Password CLI completion (macOS / if op is installed)
if command -v op &>/dev/null; then
  _op_completion_cache="${XDG_CACHE_HOME:-$HOME/.cache}/op_completion.zsh"
  if [[ ! -f "$_op_completion_cache" ]]; then
    op completion zsh >| "$_op_completion_cache" && echo "compdef _op op" >> "$_op_completion_cache"
  fi
  source "$_op_completion_cache"
fi

eval "$(zoxide init zsh)"

if [[ "$OSTYPE" == "darwin"* ]]; then
  bindkey '^[[1;3D' backward-word      # alt-left
  bindkey '^[[1;3C' forward-word       # alt-right
  bindkey '\e[H' beginning-of-line     # home
  bindkey '\e[F' end-of-line           # end
  bindkey '^[[1;9D' beginning-of-line  # cmd-left
  bindkey '^[[1;9C' end-of-line        # cmd-right
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  bindkey '^[[1;3D' backward-word      # alt-left
  bindkey '^[[1;3C' forward-word       # alt-right
  bindkey '^[[H' beginning-of-line     # home
  bindkey '^[[F' end-of-line           # end
fi

# Linux: source atuin env so binary is in PATH before init
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  [ -s "$HOME/.atuin/bin/env" ] && source "$HOME/.atuin/bin/env"
fi

eval "$(atuin init zsh)"

# macOS-only: Homebrew terraform completion
if [[ "$OSTYPE" == "darwin"* ]]; then
  complete -o nospace -C /opt/homebrew/bin/terraform terraform
elif command -v terraform &>/dev/null; then
  complete -o nospace -C "$(which terraform)" terraform
fi

# macOS-only: Homebrew shell env (cached)
if [[ "$OSTYPE" == "darwin"* ]]; then
  _brew_shellenv_cache="${XDG_CACHE_HOME:-$HOME/.cache}/brew_shellenv.zsh"
  if [[ ! -f "$_brew_shellenv_cache" || /opt/homebrew/bin/brew -nt "$_brew_shellenv_cache" ]]; then
    /opt/homebrew/bin/brew shellenv >| "$_brew_shellenv_cache"
  fi
  source "$_brew_shellenv_cache"
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# macOS-only: Homebrew postgresql and Antigravity
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
  export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
fi

export PATH="$HOME/.local/bin:$PATH"
