.PHONY: setup desktop desktop-*

ANSIBLE_PLAYBOOK := ansible-playbook \
		setup.yml -vv -K \
		-i HOSTS  \
		-e 'ansible_python_interpreter="/usr/bin/python3"' \
		--vault-password-file=/home/carlosr/.ansible_pass

setup:
	apt-get install -y python3-pip
	pip3 install -I -r ansible-requirements.txt

desktop-dot: TAGS = -t 'dot'
desktop-dot: desktop-tags

desktop-ssh: TAGS = -t 'ssh'
desktop-ssh: desktop-tags

desktop-sudo: TAGS = -t 'sudo'
desktop-sudo: desktop-tags

desktop-golang: TAGS = -t 'golang'
desktop-golang: desktop-tags

desktop-k8s: TAGS = -t 'k8s'
desktop-k8s: desktop-tags

desktop-wls: TAGS = -t 'wsl'
desktop-wls: desktop-tags

desktop-apt: TAGS = -t 'apt'
desktop-apt: desktop-tags

desktop-pip: TAGS = -t 'pip'
desktop-pip: desktop-tags

desktop-tags:
	$(ANSIBLE_PLAYBOOK) ${TAGS}

desktop:
	$(ANSIBLE_PLAYBOOK)
