build_devops:
	docker build -t devops .

devops: build_devops
	docker run --name devops -it --rm -v ./shared:/shared devops /bin/bash
