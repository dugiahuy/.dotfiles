# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# Prezto
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Asdf
. "$HOMEBREW_CELLAR/asdf/$(asdf version | cut -c 2-)/libexec/asdf.sh"

# PATH
# Golang
export PATH="$(go env GOPATH)/bin:$PATH"

# Development ENV
source $HOME/dotfiles/.env


# Fasd
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias z='fasd_cd -d'     # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # cd with interactive selection

# Kubernetes
alias k='kubectl'

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
