# Repository maintenance

- Run `make validate INVENTORY=inventory.example` after changing playbooks or dotfiles. Run `make check` before applying changes to a host.
- Use `scripts/audit-macos` to compare a live Mac with the tracked package lists. Use `scripts/command-usage` to rank shell commands. The history script must never print command arguments.
- Keep package lists small. Add a command-line tool when it is part of the base setup or has clear, repeated use. Add desktop apps only when they belong on every new machine.
- On macOS, use Homebrew `n` with `N_PREFIX=~/.n` as the only Node.js version manager. Install pnpm and the other global Node tools into that prefix. Do not add asdf or a Homebrew Node formula.
- Keep machine-specific shell config in `~/.zshrc.local` and secrets in `~/.zsh_env_vars`. Never copy tokens, private keys, credential helpers, or credential files into this repo.
- Keep signing and host auth in `~/.gitconfig.local`. The tracked Git config may include that file but must not contain a machine's signing key path or generated credential entries.
- Neovim config lives in `KyleAMathews/kickstart.nvim`. This repo may clone it, but must not copy, update, or overwrite an existing checkout.
- Package upgrades and firewall changes stay opt-in. A normal playbook run should install missing state without bulk-upgrading the host.
- Dotfile tasks should back up files they replace. Do not change files in the live home directory while maintaining this repo unless the user asks for an install.

# Checks

- Keep `scripts/validate` portable across the supported hosts. Optional app-specific checks should skip cleanly when the app is absent.
- Update the audit scripts when package-list layout changes. They are read-only and should not call install, upgrade, login, or auth commands.
- Before committing, run `git diff --check` and inspect deleted config for secrets. If a secret was ever committed, tell the user to revoke it; do not rewrite Git history without an explicit request.
