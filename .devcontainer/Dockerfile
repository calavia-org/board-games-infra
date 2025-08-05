# Devcontainer para Board Games Infrastructure
# Imagen base con herramientas de desarrollo preinstaladas

FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Metadatos
LABEL maintainer="Calavia Gaming Infrastructure Team"
LABEL description="Devcontainer optimizado para Board Games Infrastructure con pre-commit hooks"

# Variables de entorno
ENV DEBIAN_FRONTEND=noninteractive
ENV TERRAFORM_VERSION=1.8.5
ENV TERRAFORM_DOCS_VERSION=v0.17.0
ENV KUBECTL_VERSION=v1.31.0
ENV TFLINT_VERSION=v0.47.0
ENV TRIVY_VERSION=0.44.0
ENV INFRACOST_VERSION=0.10.29

# Actualizar sistema e instalar dependencias base
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    unzip \
    jq \
    git \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    shellcheck \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Instalar Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -f docker

# Instalar Node.js (para algunas herramientas)
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario vscode si no existe y configurar permisos de Docker
RUN if ! id -u vscode > /dev/null 2>&1; then \
    groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid vscode --shell /bin/bash --create-home vscode \
    && echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/vscode; \
    fi \
    && usermod -aG docker vscode

# Todas las instalaciones como root (ya somos root por defecto)
# Instalar AWS CLI v2
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then AWS_ARCH="x86_64"; \
    elif [ "$ARCH" = "arm64" ]; then AWS_ARCH="aarch64"; \
    else AWS_ARCH="x86_64"; fi && \
    curl -L "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Instalar Terraform
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then TF_ARCH="amd64"; \
    elif [ "$ARCH" = "arm64" ]; then TF_ARCH="arm64"; \
    else TF_ARCH="amd64"; fi && \
    curl -L -o terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TF_ARCH}.zip" \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform.zip

# Instalar terraform-docs
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then TFDOCS_ARCH="amd64"; \
    elif [ "$ARCH" = "arm64" ]; then TFDOCS_ARCH="arm64"; \
    else TFDOCS_ARCH="amd64"; fi && \
    curl -L -o terraform-docs.tar.gz "https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-linux-${TFDOCS_ARCH}.tar.gz" \
    && tar -xzf terraform-docs.tar.gz \
    && chmod +x terraform-docs \
    && mv terraform-docs /usr/local/bin/ \
    && rm terraform-docs.tar.gz

# Instalar kubectl
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then KUBECTL_ARCH="amd64"; \
    elif [ "$ARCH" = "arm64" ]; then KUBECTL_ARCH="arm64"; \
    else KUBECTL_ARCH="amd64"; fi && \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# Instalar TFLint
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then TFLINT_ARCH="amd64"; \
    elif [ "$ARCH" = "arm64" ]; then TFLINT_ARCH="arm64"; \
    else TFLINT_ARCH="amd64"; fi && \
    curl -L -o tflint.zip "https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_${TFLINT_ARCH}.zip" \
    && unzip tflint.zip \
    && mv tflint /usr/local/bin/ \
    && rm tflint.zip

# Instalar Trivy
RUN sh -c 'echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" > /etc/apt/sources.list.d/trivy.list' \
    && curl -qsSL https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends trivy \
    && rm -rf /var/lib/apt/lists/*

# Instalar Infracost
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then INFRACOST_ARCH="amd64"; \
    elif [ "$ARCH" = "arm64" ]; then INFRACOST_ARCH="arm64"; \
    else INFRACOST_ARCH="amd64"; fi && \
    curl -L -o infracost.tar.gz "https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-${INFRACOST_ARCH}.tar.gz" \
    && tar -xzf infracost.tar.gz \
    && chmod +x infracost-linux-${INFRACOST_ARCH} \
    && mv infracost-linux-${INFRACOST_ARCH} /usr/local/bin/infracost \
    && rm infracost.tar.gz

# Instalar herramientas NPM globalmente
RUN npm install -g \
    markdownlint-cli@0.39.0 \
    @commitlint/cli@18.4.3 \
    @commitlint/config-conventional@18.4.3

# Cambiar a usuario vscode para configuraciones de usuario
USER vscode
WORKDIR /home/vscode

# Instalar Python tools y pre-commit
RUN pip install --no-cache-dir \
    pre-commit==3.5.0 \
    yamllint==1.35.1 \
    ansible-lint==6.22.2 \
    && echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> ~/.bashrc

# Configurar Git globalmente (valores por defecto)
RUN git config --global init.defaultBranch main \
    && git config --global pull.rebase false \
    && git config --global core.autocrlf input

# Crear directorios necesarios
RUN mkdir -p ~/.aws ~/.kube ~/.terraform.d

# Configurar aliases útiles
RUN echo 'alias tf="terraform"' >> ~/.bashrc \
    && echo 'alias tfdocs="terraform-docs"' >> ~/.bashrc \
    && echo 'alias k="kubectl"' >> ~/.bashrc \
    && echo 'alias pc="pre-commit"' >> ~/.bashrc \
    && echo 'alias pcr="pre-commit run"' >> ~/.bashrc \
    && echo 'alias pcra="pre-commit run --all-files"' >> ~/.bashrc \
    && echo 'alias ll="ls -alF"' >> ~/.bashrc \
    && echo 'alias la="ls -A"' >> ~/.bashrc \
    && echo 'alias l="ls -CF"' >> ~/.bashrc

# Función para cambiar contextos de kubectl
RUN echo "kctx() {" >> ~/.bashrc \
    && echo "    if [[ \$1 == \"staging\" ]]; then" >> ~/.bashrc \
    && echo "        aws eks update-kubeconfig --region us-west-2 --name board-games-staging" >> ~/.bashrc \
    && echo "    elif [[ \$1 == \"production\" ]]; then" >> ~/.bashrc \
    && echo "        aws eks update-kubeconfig --region us-west-2 --name board-games-production" >> ~/.bashrc \
    && echo "    else" >> ~/.bashrc \
    && echo "        echo \"Uso: kctx [staging|production]\"" >> ~/.bashrc \
    && echo "    fi" >> ~/.bashrc \
    && echo "}" >> ~/.bashrc

# Configurar prompt mejorado
RUN echo 'export PS1="\u@\h:\w\$ "' >> ~/.bashrc

# Agregar configuración de Docker al bashrc para verificación automática
RUN echo '' >> ~/.bashrc \
    && echo '# Verificar permisos de Docker al iniciar sesión' >> ~/.bashrc \
    && echo 'if [ -S /var/run/docker.sock ] && ! docker info >/dev/null 2>&1; then' >> ~/.bashrc \
    && echo '    echo "⚠️  Configurando permisos de Docker..."' >> ~/.bashrc \
    && echo '    sudo chown root:docker /var/run/docker.sock 2>/dev/null || true' >> ~/.bashrc \
    && echo '    sudo chmod 664 /var/run/docker.sock 2>/dev/null || true' >> ~/.bashrc \
    && echo 'fi' >> ~/.bashrc

# Cambiar a root para crear el script de Docker setup
USER root

# Crear script de entrada para configurar permisos de Docker
RUN echo '#!/bin/bash' > /usr/local/bin/docker-setup.sh \
    && echo 'set -e' >> /usr/local/bin/docker-setup.sh \
    && echo '' >> /usr/local/bin/docker-setup.sh \
    && echo '# Configurar permisos de Docker socket si existe' >> /usr/local/bin/docker-setup.sh \
    && echo 'if [ -S /var/run/docker.sock ]; then' >> /usr/local/bin/docker-setup.sh \
    && echo '    echo "Configurando permisos de Docker socket..."' >> /usr/local/bin/docker-setup.sh \
    && echo '    chown root:docker /var/run/docker.sock' >> /usr/local/bin/docker-setup.sh \
    && echo '    chmod 664 /var/run/docker.sock' >> /usr/local/bin/docker-setup.sh \
    && echo '    echo "✅ Permisos de Docker configurados correctamente"' >> /usr/local/bin/docker-setup.sh \
    && echo 'else' >> /usr/local/bin/docker-setup.sh \
    && echo '    echo "⚠️  Docker socket no encontrado en /var/run/docker.sock"' >> /usr/local/bin/docker-setup.sh \
    && echo 'fi' >> /usr/local/bin/docker-setup.sh \
    && echo '' >> /usr/local/bin/docker-setup.sh \
    && echo '# Ejecutar comando pasado como argumento' >> /usr/local/bin/docker-setup.sh \
    && echo 'exec "$@"' >> /usr/local/bin/docker-setup.sh \
    && chmod +x /usr/local/bin/docker-setup.sh

# Volver a usuario vscode
USER vscode

# Verificar instalaciones (asegura ~/.local/bin en PATH para pre-commit)
RUN export PATH="$HOME/.local/bin:$PATH" \
    && echo "Verificando instalaciones..." \
    && aws --version \
    && terraform version \
    && terraform-docs --version \
    && kubectl version --client \
    && tflint --version \
    && trivy --version \
    && infracost --version \
    && docker --version \
    && docker compose version \
    && pre-commit --version \
    && echo "✅ Todas las herramientas instaladas correctamente"

# Volver al directorio de trabajo por defecto
WORKDIR /workspace

# Configurar punto de entrada con setup de Docker
ENTRYPOINT ["/usr/local/bin/docker-setup.sh"]

# Punto de entrada por defecto
CMD ["/bin/bash"]
