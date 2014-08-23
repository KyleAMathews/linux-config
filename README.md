Install my dotfiles and common utilities on the different machines I work on.

Uses Ansible to make it all easy.

To run it do something like `ansible-playbook dev.yml -i ~/.ansible_hosts -Kv`

The `-K` is necessary for localhost. Otherwise don't use that flag.

A sample .ansible_hosts file might look like this:

````
localhost              ansible_connection=local

[vps]
104.131.132.128   ansible_ssh_user=root
````

## Macs
Install Homebrew manually and then run `brew install ansible` to get
Ansible working. Then clone this repo, create a ~/.ansible_hosts file, and run the above command.

### Manual post-install steps which perhaps could be automated but which aren't atm

* Import iterm2 solarized theme from the downloads folder
* Set iterm2 font to inconsolata 13pt
* Copy ssh keys
* run `brew cask alfred link`
* Set iterm2 scrollback to unlimited
* Up ULIMIT

## Docker image
These dotfiles + config + Ubuntu are now a Docker image!

To run it with your ssh port forwarding:

`docker run -rm -t -i -v $(dirname $SSH_AUTH_SOCK):$(dirname
$SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK kyma/dev-image bash`
