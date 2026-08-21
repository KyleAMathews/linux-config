export _Z_DATA="$HOME/.local/state/z/data"

if [ -f "$HOME/.local/share/z/z.sh" ]; then
  source "$HOME/.local/share/z/z.sh"
elif [ -f /opt/homebrew/etc/profile.d/z.sh ]; then
  source /opt/homebrew/etc/profile.d/z.sh
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

if command -v wt >/dev/null 2>&1; then
  eval "$(wt config shell init zsh)"
fi

if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi
