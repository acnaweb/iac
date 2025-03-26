FROM ubuntu:latest

# Mantenedor da imagem (opcional)
LABEL maintainer="acnaweb"

# Definir versão do Terraform
ENV TERRAFORM_VERSION=1.8.4
ENV GCLOUD_DIR=/opt/google-cloud-cli

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    unzip \
    gnupg \
    build-essential \
    git \
    openssh-client \
    iputils-ping \
    groff \
    nano \
    telnet && \
    apt-get clean && \    
    rm -rf /var/lib/apt/lists/*

# *****************************************************
# Criar a pasta Downloads e instalar o AWS CLI (para acessar a AWS)
RUN mkdir /opt/downloads && \
    cd /opt/downloads && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# *****************************************************
# Instalar o Azure CLI (para acessar a Azure)
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Instalar o Databricks CLI
RUN curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/main/install.sh | sh

# Instalar Google Cloud CLI
RUN curl -o /tmp/gcloud-cli.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz && \
    mkdir -p $GCLOUD_DIR && \
    tar -xvzf /tmp/gcloud-cli.tar.gz --strip-components=1 -C $GCLOUD_DIR && \
    $GCLOUD_DIR/install.sh --quiet && \
    rm /tmp/gcloud-cli.tar.gz

# Adicionar gcloud ao PATH e ativar a configuração do shell
RUN echo "source $GCLOUD_DIR/path.bash.inc" >> /etc/profile.d/gcloud.sh && \
    echo "source $GCLOUD_DIR/completion.bash.inc" >> /etc/profile.d/gcloud.sh && \
    echo "export PATH=$GCLOUD_DIR/bin:\$PATH" >> /etc/profile.d/gcloud.sh

# Instalar Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin/ && \
    rm /tmp/terraform.zip

# Instalar Terragrunt
RUN curl -Lo terragrunt https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64 && \
    chmod +x terragrunt && \
    sudo mv terragrunt /usr/local/bin/

# Configurar o SHELL para bash (garante que o source funcione corretamente)
SHELL ["/bin/bash", "-c"]

# Aplicar as configurações para a sessão de build do Dockerfile
RUN source /etc/profile.d/gcloud.sh && \
    gcloud --version && \
    terraform --version

# Expor o PATH para que os comandos gcloud e terraform funcionem ao iniciar o contêiner
ENV PATH="$GCLOUD_DIR/bin:/usr/local/bin:$PATH"

WORKDIR /shared

# Comando padrão ao rodar o contêiner
CMD ["/bin/bash"]
