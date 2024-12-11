iac:
	docker build -t iac .
	docker run --name iac -it --rm -v ./src:/shared iac /bin/bash
