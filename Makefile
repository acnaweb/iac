iac:
	docker build -t iac .
	docker run --name iac -it --rm -v ./src:/shared devops /bin/bash
