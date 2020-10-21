SHELL = /bin/bash -euo pipefail

compile:
	python -c "import bcc; bcc.BPF(src_file=b'xdp.c')"

deps:
	sudo pip install --upgrade -r requirements.txt

lint:
	flake8 --ignore=F403,F405 .

test:
	sudo pytest test.py

clean:
	find . -name "*.py[cod]" -o -name "*__pycache__" | xargs rm -rf
