SHELL = /bin/bash -euo pipefail

compile:
	python -c "import bcc; bcc.BPF(src_file=b'xdp.c')"

deps:
	sudo pip install --upgrade -r requirements.txt

lint:
	flake8 --max-line-length 100 --ignore=F403,F405 .

test:
	# The "-p no:warnings" arg can be removed once
	# https://github.com/iovisor/bcc/pull/3144 is merged
	sudo pytest test.py -p no:warnings

clean:
	find . -name "*.py[cod]" -o -name "*__pycache__" | xargs rm -rf
