Install my dotfiles and common utilities on the different machines I work on.

Uses Ansible to make it all easy.

To run it do something like `ansible-playbook dev.yml -i ~/.ansible_hosts -Kv`

The `-K` is necessary for localhost. Otherwise don't use that flag.
