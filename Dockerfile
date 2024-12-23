# Use a imagem oficial do Ubuntu como base
FROM ubuntu:latest

# Mantenedor da imagem (opcional)
LABEL maintainer="acnaweb"

# Atualizar os pacotes do sistema e instalar dependências necessárias
RUN apt-get update && \
    apt-get install -y git wget unzip curl \
    openssh-client iputils-ping groff nano telnet

# Definir a versão do Terraform (ajuste conforme necessário)
ENV TERRAFORM_VERSION=1.7.5

# Baixar e instalar Terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Criar a pasta /shared como um ponto de montagem para um volume
RUN mkdir /shared
VOLUME /shared

# Criar a pasta Downloads e instalar o AWS CLI (para acessar a AWS)
RUN mkdir Downloads && \
    cd Downloads && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Instalar o Azure CLI (para acessar a Azure)
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Instalar o gcloud CLI (para acessar a GCP)
RUN cd Downloads && \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz && \
    tar -xf google-cloud-cli-linux-x86_64.tar.gz && \
    ./google-cloud-sdk/install.sh -q 

# source google-cloud-sdk/completion.bash.inc && \
# source google-cloud-sdk/path.bash.inc

# Definir o comando padrão para execução quando o container for iniciado
CMD ["/bin/bash"]
