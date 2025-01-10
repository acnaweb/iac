iac:
	docker build -t iac .
	docker run --name iac -it --rm -v .:/shared iac /bin/bash
