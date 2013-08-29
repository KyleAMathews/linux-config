
check:
	ansible-playbook -i ~/ansible_hosts dev.yml --check --diff

install:
	ansible-playbook -i ~/ansible_hosts dev.yml

facts:
	ansible all -i ~/ansible_hosts -m setup
