.PHONY: setup desktop desktop-*

CHECk =
ifdef CHECK
CHECK = --check
endif

UV_CLI	?= $(CURDIR)/bin/uv
CLI_ARCH	:= $(shell uname -m)

PYTHON_VENV		?= venv
PYTHON_BIN		?= $(CURDIR)/$(PYTHON_VENV)/bin/python3
PYTHON_SOURCE	?= . $(CURDIR)/$(PYTHON_VENV)/bin/activate

ANSIBLE_EXTRA_ARGS := \
		--vault-password-file=$(HOME)/.ansible_pass

ANSIBLE_PLAYBOOK := ansible-playbook \
		setup.yml \
		--verbose \
		--ask-become-pass \
		$(CHECK) \
		$(ANSIBLE_EXTRA_ARGS)

ANSIBLE_PLAYBOOK_CMD	:= $(UV_CLI) run $(ANSIBLE_PLAYBOOK)

ifeq ($(shell uname -s),Darwin)
	CLI_OS=darwin
	CLI_UV_OS=apple-darwin
	ifeq ($(shell uname -m),arm64)
		CLI_ARCH=aarch64
	endif
else
	CLI_OS=linux
	CLI_UV_OS=unknown-linux-gnu
endif

bin/uv	: UV_VERSION=0.7.9
bin/uv	:
	@(mkdir -p $(CURDIR)/bin)
	@(echo "Downloading https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-${CLI_ARCH}-${CLI_UV_OS}.tar.gz")
	@(curl -L --fail --remote-name-all https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-${CLI_ARCH}-${CLI_UV_OS}.tar.gz{,.sha256})
	@(shasum -a 256 -c uv-${CLI_ARCH}-${CLI_UV_OS}.tar.gz.sha256)
	@(tar -xzvf uv-${CLI_ARCH}-${CLI_UV_OS}.tar.gz --strip-components=1 -C $(CURDIR)/bin/)
	@(rm uv-*)
	@($(UV_CLI) --version)

# https://github.com/astral-sh/uv/releases/download/0.7.9/uv-aarch64-apple-darwin.tar.gz
# https://github.com/astral-sh/uv/releases/download/0.7.9/uv-arm64-apple-darwin.tar.gz
.PHONY : version
version:
	@($(UV_CLI) run ansible --version)

.PHONY : setup/venv
setup/venv: venv

.PHONY : setup/python
setup/python:
	@($(UV_CLI) venv)
	@($(UV_CLI) pip sync ansible-requirements.txt)

.PHONY : setup/ansible
setup/ansible: bin/uv
setup/ansible: setup/python
setup/ansible:
	@($(UV_CLI) run ansible-galaxy install -r $(CURDIR)/ansible-galaxy-requirements.yml)

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

desktop-gui: TAGS = -t 'gui'
desktop-gui: desktop-tags

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

desktop-nvidia-cuda: TAGS = -t 'nvidia-cuda'
desktop-nvidia-cuda: desktop-tags

desktop-keepassxc: TAGS = -t 'keepassxc'
desktop-keepassxc: desktop-tags

desktop-tags:
	@($(ANSIBLE_PLAYBOOK_CMD) ${TAGS})

.PHONY : debug
debug:
	@(echo "$(ANSIBLE_PLAYBOOK_CMD) ${TAGS}")

desktop:
	@($(ANSIBLE_PLAYBOOK_CMD);)

.PHONY : bob-book
bob-book: TAGS += -t 'wsl'
bob-book: TAGS += -t 'packages'
bob-book: TAGS += -t 'sudo'
bob-book: TAGS += -t 'ssh'
bob-book: TAGS += -t 'dot'
bob-book: desktop-tags

.PHONY : bob-can
bob-can: TAGS += -t 'wsl'
bob-can: TAGS += -t 'packages'
bob-can: TAGS += -t 'gui'
bob-can: TAGS += -t 'sudo'
bob-can: TAGS += -t 'ssh'
bob-can: TAGS += -t 'dot'
bob-can: TAGS += -t 'docker'
bob-can: desktop-tags

.PHONY : bob-go
bob-go: TAGS += -t 'wsl'
bob-go: TAGS += -t 'packages'
bob-go: TAGS += -t 'sudo'
bob-go: TAGS += -t 'ssh'
bob-go: TAGS += -t 'dot'
bob-go: TAGS += -t 'docker'
bob-go: desktop-tags

.PHONY : dd-osx
dd-osx: TAGS += -t 'osx'
dd-osx: TAGS += -t 'dot'
dd-osx: TAGS += -t 'ssh'
dd-osx: TAGS += -t 'golang'
dd-osx: desktop-tags

.PHONY : bob-pi
bob-pi: TAGS += -t 'packages'
bob-pi: TAGS += -t 'sudo'
bob-pi: TAGS += -t 'ssh'
bob-pi: TAGS += -t 'dot'
bob-pi: desktop-tags

.PHONY : bob-frame
bob-frame: TAGS += -t 'wsl'
bob-frame: TAGS += -t 'packages'
bob-frame: TAGS += -t 'gui'
bob-frame: TAGS += -t 'sudo'
bob-frame: TAGS += -t 'ssh'
bob-frame: TAGS += -t 'dot'
bob-frame: TAGS += -t 'docker'
bob-frame: desktop-tags

.PHONY : bob-frame-nix
bob-frame-nix: TAGS += -t 'docker'
bob-frame-nix: TAGS += -t 'dot'
bob-frame-nix: TAGS += -t 'packages'
bob-frame-nix: TAGS += -t 'ssh'
bob-frame-nix: TAGS += -t 'sudo'
bob-frame-nix: TAGS += -t 'vscode'
bob-frame-nix: TAGS += -t 'chrome'
bob-frame-nix: TAGS += -t 'keepassxc'
bob-frame-nix: desktop-tags

.PHONY : lint
lint:
	@(	\
		$(PYTHON_SOURCE); \
		yamllint .; \
	)

.PHONY : ansible-facts
ansible-facts:
	@(	\
		$(PYTHON_SOURCE); \
		ansible all $(ANSIBLE_EXTRA_ARGS) -m ansible.builtin.setup -a 'gather_subset=!all,!min,os_family,distribution,user,env,system,date_time,platform,lsb'; \
	)
