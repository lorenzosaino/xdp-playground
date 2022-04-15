SHELL = /bin/bash -euo pipefail

compile: ## Compile XDP code
	python -c "import bcc; bcc.BPF(src_file=b'xdp.c')"

deps: ## Install all Python dependencies
	sudo pip install --upgrade -r requirements.txt

lint: ## Lint Python code
	flake8 --max-line-length 100 --ignore=F403,F405 .

test: ## Run tests
	sudo pytest test.py

clean: ## Delete build files
	find . -name "*.py[cod]" -o -name "*__pycache__" | xargs rm -rf

vagrant-%: ## Run any target of this Makefile in a VM
	vagrant ssh -c "cd /vagrant; make $*"

help: ## Print help
	@(grep -E '^[a-zA-Z0-9_%-]+:.*?## .*$$' Makefile || true )| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
