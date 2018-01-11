.PHONY: desktop

desktop: 
	ansible-playbook \
		setup.yml -vv -K \
		-i HOSTS  \
		-e 'ansible_python_interpreter="/usr/bin/python3"' \
		--vault-password-file=/home/carlosr/.ansible_pass
