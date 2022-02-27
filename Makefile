.PHONY: setup desktop desktop-*

CHECk =
ifdef CHECK
CHECK = --check
endif


PYTHON_VENV		?= venv
PYTHON_BIN		?= $(CURDIR)/$(PYTHON_VENV)/bin/python3
PYTHON_SOURCE	?= . $(CURDIR)/$(PYTHON_VENV)/bin/activate

ANSIBLE_EXTRA_ARGS := --inventory-file HOSTS \
		--extra-vars 'ansible_python_interpreter="$(CURDIR)/$(PYTHON_VENV)/bin/python"' \
		--vault-password-file=$(HOME)/.ansible_pass

ANSIBLE_PLAYBOOK := ansible-playbook \
		setup.yml \
		--verbose \
		--ask-become-pass \
		$(CHECK) \
		$(ANSIBLE_EXTRA_ARGS)

ANSIBLE_PLAYBOOK_CMD	:= $(PYTHON_SOURCE); $(ANSIBLE_PLAYBOOK)

.PHONY : setup/apt
setup/apt:
	apt-get install -y python3-apt python3-venv

.PHONY : version
version:
	@ansible --version

venv:
	@(python3 -m venv $(PYTHON_VENV))
	@(	\
		$(PYTHON_SOURCE); \
		python --version; \
		pip --version; \
		pip install --upgrade \
			pip \
			wheel; \
		pip --version; \
	)

.PHONY : setup/venv
setup/venv: venv

.PHONY : setup/python
setup/python: setup/venv
	@(	\
		$(PYTHON_SOURCE); \
		python --version; \
		pip --version; \
		pip install \
		--upgrade \
		--requirement $(CURDIR)/ansible-requirements.txt; \
	)

.PHONY : setup/ansible
setup/ansible: setup/python
	@(	\
		$(PYTHON_SOURCE); \
		python --version; \
		pip --version; \
		ansible-galaxy install -r ansible-galaxy-requirements.yml; \
	)

.PHONY : setup
setup: setup/ansible

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

desktop-rust: TAGS = -t 'rust'
desktop-rust: desktop-tags

desktop-limits: TAGS = -t 'limits'
desktop-limits: desktop-tags

desktop-chrome: TAGS = -t 'chrome'
desktop-chrome: desktop-tags

desktop-newrelic-infra: TAGS = -t 'newrelic-infra'
desktop-newrelic-infra: desktop-tags

desktop-tags:
	@($(ANSIBLE_PLAYBOOK_CMD) ${TAGS};)

.PHONY : debug
debug:
	@(echo "$(ANSIBLE_PLAYBOOK_CMD) ${TAGS}";)

desktop:
	@($(ANSIBLE_PLAYBOOK_CMD);)

.PHONY : bob-book
bob-book: TAGS += -t 'wsl'
bob-book: TAGS += -t 'packages'
bob-book: TAGS += -t 'sudo'
bob-book: TAGS += -t 'ssh'
bob-book: TAGS += -t 'dot'
bob-book: desktop-tags

.PHONY : bob-go
bob-go: TAGS += -t 'wsl'
bob-go: TAGS += -t 'packages'
bob-go: TAGS += -t 'sudo'
bob-go: TAGS += -t 'ssh'
bob-go: TAGS += -t 'dot'
bob-go: desktop-tags

.PHONY : dd-osx
dd-osx: TAGS += -t 'osx'
dd-osx: TAGS += -t 'dot'
dd-osx: TAGS += -t 'ssh'
dd-osx: TAGS += -t 'golang'
dd-osx: desktop-tags

.PHONY : lint
lint:
	@(	\
		$(PYTHON_SOURCE); \
		yamllint .; \
	)

.PHONY : ansible-facts
ansible-facts:
	@(ansible local $(ANSIBLE_EXTRA_ARGS) -m ansible.builtin.setup)
