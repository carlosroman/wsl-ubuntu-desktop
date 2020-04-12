.PHONY: setup desktop desktop-*

ANSIBLE_PLAYBOOK := ansible-playbook \
		setup.yml -vv -K \
		-i HOSTS  \
		-e 'ansible_python_interpreter="/usr/bin/python3"' \
		--vault-password-file=${HOME}/.ansible_pass

setup:
	apt-get install -y python3-pip python3-apt python3-venv
	pip3 install \
		--upgrade \
		--ignore-installed \
		--requirement ansible-requirements.txt
.PHONY : setup/ansible
setup/ansible:
	@(ansible-galaxy install -r requirements.yml)

desktop-dot: TAGS = -t 'dot'
desktop-dot: desktop-tags

desktop-ssh: TAGS = -t 'ssh'
desktop-ssh: desktop-tags

desktop-sudo: TAGS = -t 'sudo'
desktop-sudo: desktop-tags

desktop-golang: TAGS = -t 'golang'
desktop-golang: desktop-tags

desktop-java: TAGS = -t 'java'
desktop-java: desktop-tags

desktop-k8s: TAGS = -t 'k8s'
desktop-k8s: desktop-tags

desktop-wls: TAGS = -t 'wsl'
desktop-wls: desktop-tags

desktop-apt: TAGS = -t 'apt'
desktop-apt: desktop-tags

desktop-packages: TAGS = -t 'packages'
desktop-packages: desktop-tags

desktop-docker: TAGS = -t 'docker'
desktop-docker: desktop-tags

desktop-pip: TAGS = -t 'pip'
desktop-pip: desktop-tags

desktop-adr: TAGS = -t 'adr'
desktop-adr: desktop-tags

desktop-vscode: TAGS = -t 'vscode'
desktop-vscode: desktop-tags

desktop-limits: TAGS = -t 'limits'
desktop-limits: desktop-tags

desktop-newrelic-infra: TAGS = -t 'newrelic-infra'
desktop-newrelic-infra: desktop-tags

desktop-tags:
	$(ANSIBLE_PLAYBOOK) ${TAGS}

desktop:
	$(ANSIBLE_PLAYBOOK)

. PHONY : lint
lint:
	@(yamllint .)
