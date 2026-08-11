alias vi='nvim'
alias vim='nvim'

if command -v eza >/dev/null 2>&1; then
  alias ls='eza -lahr -snew --group-directories-first'
fi
