# Development machine config

This Ansible playbook installs my dotfiles, command-line tools, and desktop apps on macOS, Debian, and Red Hat systems.

## Set up a new Mac

1. Install Apple's command-line tools:

   ```sh
   xcode-select --install
   ```

2. Install [Homebrew](https://brew.sh), then install Ansible:

   ```sh
   brew install ansible ansible-lint
   ```

3. Clone this repo and create a local inventory:

   ```sh
   cp inventory.example inventory
   make bootstrap
   make validate INVENTORY=inventory.example
   make check
   make install
   ```

The macOS run does not need sudo. On Linux, pass `BECOME_FLAGS=--ask-become-pass` to `make check` or `make install` when the account needs a sudo password.

The playbook installs missing packages but does not upgrade every package by default. To opt into a full package upgrade, run `make install ANSIBLE_ARGS='--extra-vars upgrade_system_packages=true'`. The firewall tasks are also opt-in; enable them with `ANSIBLE_ARGS='--extra-vars configure_ufw=true'` on a Debian host.

On macOS, Homebrew installs `n`, then Ansible installs the latest Node.js LTS release under `~/.n`. Global npm tools, including pnpm, use the same user-owned prefix. No sudo access or second Node version manager is needed.

## Maintenance

Run `make validate INVENTORY=inventory.example` after changing the playbook or dotfiles. It runs Ansible lint and syntax checks, shell parsers, Git config parsing, Ghostty's validator when available, and whitespace checks.

On a Mac, `make audit-live` compares installed Homebrew formulae, casks, and global npm packages with the tracked lists. It reports drift but changes nothing. To see which commands are worth managing, run `scripts/command-usage`; it prints command names and counts only, never command arguments.

## Managed config

The tracked `.zshrc` loads small files from `~/.config/zsh`. Put machine-specific aliases in `~/.zshrc.local`; keep secrets in `~/.zsh_env_vars`.

Neovim config comes from [KyleAMathews/kickstart.nvim](https://github.com/KyleAMathews/kickstart.nvim). Commit changes in that repo before setting up another machine; this playbook clones it but does not overwrite or update an existing checkout.

The tracked Git config includes `~/.gitconfig.local`. To enable commit signing, copy the example and edit the public-key path:

```sh
cp templates/gitconfig.local.example ~/.gitconfig.local
gh auth setup-git
```

## Private environment variables

Keep tokens and other secrets out of this repo. Put shell exports in `~/.zsh_env_vars`; `.zshrc` loads that file when it exists. Copy SSH keys through a secure channel rather than committing them here.

## Other hosts

Add hosts or groups to the untracked `inventory` file. For example:

```ini
localhost ansible_connection=local

[vps]
example.com ansible_user=root
```

Run a remote host without the local sudo prompt when appropriate:

```sh
ansible-playbook --inventory inventory dev.yml --limit vps
```

## Docker image

The Dockerfile provides an Ubuntu test and development image:

```sh
docker build --tag dev-image .
docker run --rm --interactive --tty dev-image
```
