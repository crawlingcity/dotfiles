# Ghostty integration must be loaded by shells created inside tmux as well.
if [[ -n "$GHOSTTY_RESOURCES_DIR" && -r "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration" ]]; then
  source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

# zmodload zsh/zprof
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

# Shared login/interactive environment. .profile is guarded, so login shells
# that already sourced it through .zprofile do not repeat the setup.
[[ -r "$HOME/.profile" ]] && source "$HOME/.profile"

# Keep inherited and subsequently-added command/completion paths unique.
typeset -U path PATH fpath FPATH

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
# Oh My Zsh owns compinit and its compiled completion cache.
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

# A legacy value in .exports may be stale; the signature derived from the
# current private key must take precedence for local SP-JOB processes.
if [[ -f "$HOME/.ssh/nginx-cdb-sc1-development.pem" ]]; then
  export X_CASPER_SC_GET_CHALLENGE="$(printf '%s' 'SP-JOB/Configure:ALLOW:GET' | openssl dgst -sha256 -sign "$HOME/.ssh/nginx-cdb-sc1-development.pem" | openssl enc -base64 -A)"
fi

[ -n "$USER_SHELLFILE" ] && [ -s "$USER_SHELLFILE" ] && source "$USER_SHELLFILE" # depends on .exports

ulimit -n 10240

# 1Password CLI completion (cached, no auth needed on shell startup)
_op_completion_cache="${XDG_CACHE_HOME:-$HOME/.cache}/op_completion.zsh"
if [[ -f "$_op_completion_cache" ]]; then
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

# Terraform completion, when Terraform is installed.
if command -v terraform &>/dev/null; then
  complete -o nospace -C "$(command -v terraform)" terraform
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# macOS-only: Homebrew postgresql and Antigravity
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
  export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
fi

export PATH="$HOME/.local/bin:$PATH"

# Initialise rbenv once, after all PATH changes.
if command -v rbenv &>/dev/null; then
  eval "$(command rbenv init - zsh)"
fi
