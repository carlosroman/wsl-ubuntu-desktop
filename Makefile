.PHONY: setup desktop desktop-*

CHECk =
ifdef CHECK
CHECK = --check
endif

ANSIBLE_EXTRA_ARGS := --inventory-file HOSTS \
		--extra-vars 'ansible_python_interpreter="/usr/bin/python3"' \
		--vault-password-file=${HOME}/.ansible_pass

ANSIBLE_PLAYBOOK := ansible-playbook \
		setup.yml \
		--verbose \
		--ask-become-pass \
		$(CHECK) \
		$(ANSIBLE_EXTRA_ARGS)

.PHONY: setup/apt
setup/apt:
	apt-get install -y python3-apt python3-venv

.PHONY: version
version:
	@ansible --version

venv:
	@(python3 -m venv venv)

.PHONY: setup/
setup/venv: venv

.PHONY: setup/python
setup/python:
	@pip install \
		--upgrade \
		wheel
	@pip install \
		--upgrade \
		--ignore-installed \
		--requirement ansible-requirements.txt

.PHONY : setup/ansible
setup/ansible:
	@(ansible-galaxy install -r ansible-galaxy-requirements.yml)

desktop-debug: TAGS = -t 'debug'
desktop-debug: desktop-tags

desktop-dot: TAGS = -t 'dot' -t 'ssh'
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

desktop-osx: TAGS = -t 'osx'
desktop-osx: desktop-tags

desktop-golang: TAGS = -t 'golang'
desktop-golang: desktop-tags

desktop-limits: TAGS = -t 'limits'
desktop-limits: desktop-tags

desktop-chrome: TAGS = -t 'chrome'
desktop-chrome: desktop-tags

desktop-newrelic-infra: TAGS = -t 'newrelic-infra'
desktop-newrelic-infra: desktop-tags

desktop-tags:
	$(ANSIBLE_PLAYBOOK) ${TAGS}

desktop:
	$(ANSIBLE_PLAYBOOK)

.PHONY: bob-book
bob-book: TAGS += -t 'wsl'
bob-book: TAGS += -t 'packages'
bob-book: TAGS += -t 'sudo'
bob-book: TAGS += -t 'ssh'
bob-book: TAGS += -t 'dot'
bob-book: desktop-tags

.PHONY: bob-go
bob-go: TAGS += -t 'wsl'
bob-go: TAGS += -t 'packages'
bob-go: TAGS += -t 'sudo'
bob-go: TAGS += -t 'ssh'
bob-go: TAGS += -t 'dot'
bob-go: desktop-tags

.PHONY: red-osx
red-osx: TAGS += -t 'osx'
red-osx: TAGS += -t 'dot'
red-osx: TAGS += -t 'ssh'
red-osx: TAGS += -t 'golang'
red-osx: desktop-tags

.PHONY : lint
lint:
	@(yamllint .)

.PHONY : ansible-facts
ansible-facts:
	@(ansible local $(ANSIBLE_EXTRA_ARGS) -m ansible.builtin.setup)