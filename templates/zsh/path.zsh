typeset -U path PATH

export EDITOR=nvim
export VISUAL=nvim
export GOPATH="$HOME/gocode"
export N_PREFIX="${N_PREFIX:-$HOME/.n}"

path=(
  "$N_PREFIX/bin"
  "$HOME/.local/bin"
  "$HOME/bin"
  "$GOPATH/bin"
  /opt/homebrew/bin
  /usr/local/bin
  $path
)

if [ -d "$HOME/.bun/bin" ]; then
  export BUN_INSTALL="$HOME/.bun"
  path=("$BUN_INSTALL/bin" $path)
fi

if [ -d /opt/homebrew/opt/libpq/bin ]; then
  path=(/opt/homebrew/opt/libpq/bin $path)
elif [ -d /usr/local/opt/libpq/bin ]; then
  path=(/usr/local/opt/libpq/bin $path)
fi

if [ -d "$HOME/.opencode/bin" ]; then
  path=("$HOME/.opencode/bin" $path)
fi

if [ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]; then
  path=("/Applications/Visual Studio Code.app/Contents/Resources/app/bin" $path)
fi

if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
fi
