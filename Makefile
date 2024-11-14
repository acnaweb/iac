build:
	docker build -t devops .

run: build
	docker run --name devops -it --rm -v ./shared:/shared devops /bin/bash
