#!/bin/bash

# GitHub Codespaces initialization script
# Este script configura el entorno para usar los hooks personalizados de pre-commit

set -e

echo "🚀 Inicializando entorno GitHub Codespaces..."

# Función para logging con colores
log_info() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

log_warning() {
    echo -e "\033[0;33m[WARNING]\033[0m $1"
}

# 1. Actualizar sistema
log_info "Actualizando sistema..."
sudo apt-get update -qq

# 2. Instalar dependencias requeridas
log_info "Instalando dependencias..."
sudo apt-get install -y -qq \
    curl \
    wget \
    unzip \
    git \
    jq \
    build-essential \
    python3-pip \
    python3-venv

# 3. Verificar/Instalar AWS CLI v2
if ! command -v aws &> /dev/null; then
    log_info "Instalando AWS CLI v2..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install --update
    rm -rf aws awscliv2.zip
else
    # Verificar si es versión 2.x
    AWS_VERSION=$(aws --version 2>&1 | cut -d'/' -f2 | cut -d'.' -f1)
    if [[ "$AWS_VERSION" -lt 2 ]]; then
        log_info "Actualizando AWS CLI a v2..."
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip -q awscliv2.zip
        sudo ./aws/install --update
        rm -rf aws awscliv2.zip
    else
        log_success "AWS CLI v2 ya está instalado"
    fi
fi

# 4. Verificar/Instalar Terraform
TERRAFORM_VERSION="1.8.5"
if ! command -v terraform &> /dev/null || [[ $(terraform version -json | jq -r .terraform_version) != "$TERRAFORM_VERSION" ]]; then
    log_info "Instalando Terraform $TERRAFORM_VERSION..."
    wget -q "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
    unzip -q "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
    sudo mv terraform /usr/local/bin/
    rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
else
    log_success "Terraform $TERRAFORM_VERSION ya está instalado"
fi

# 5. Verificar/Instalar kubectl
KUBECTL_VERSION="v1.31.0"
if ! command -v kubectl &> /dev/null || [[ $(kubectl version --client -o json | jq -r .clientVersion.gitVersion) != "$KUBECTL_VERSION" ]]; then
    log_info "Instalando kubectl $KUBECTL_VERSION..."
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
else
    log_success "kubectl $KUBECTL_VERSION ya está instalado"
fi

# 6. Instalar/Actualizar pre-commit
log_info "Instalando pre-commit..."
pip3 install --user pre-commit

# 7. Instalar TFLint
if ! command -v tflint &> /dev/null; then
    log_info "Instalando TFLint..."
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
    sudo mv tflint /usr/local/bin/
else
    log_success "TFLint ya está instalado"
fi

# 8. Instalar Trivy
if ! command -v trivy &> /dev/null; then
    log_info "Instalando Trivy..."
    sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" > /etc/apt/sources.list.d/trivy.list'
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -y -qq trivy
else
    log_success "Trivy ya está instalado"
fi

# 9. Instalar Infracost
if ! command -v infracost &> /dev/null; then
    log_info "Instalando Infracost..."
    curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
    sudo mv infracost /usr/local/bin/
else
    log_success "Infracost ya está instalado"
fi

# 10. Configurar Git (si no está configurado)
if [[ -z "$(git config --global user.name)" ]]; then
    log_warning "Configurando Git con valores por defecto..."
    git config --global user.name "Codespaces User"
    git config --global user.email "codespaces@calavia.org"
else
    log_success "Git ya está configurado"
fi

# 11. Instalar hooks de pre-commit
log_info "Instalando hooks de pre-commit..."
if [[ -f ".pre-commit-config.yaml" ]]; then
    # Asegurar que los scripts tienen permisos de ejecución
    chmod +x scripts/*.sh

    # Instalar hooks
    ~/.local/bin/pre-commit install

    # Verificar instalación
    ~/.local/bin/pre-commit run --all-files || log_warning "Algunos hooks fallaron, pero están instalados"
else
    log_warning "Archivo .pre-commit-config.yaml no encontrado"
fi

# 12. Crear alias útiles
log_info "Configurando aliases..."
cat >> ~/.bashrc << 'EOF'

# Aliases para Board Games Infrastructure
alias tf='terraform'
alias k='kubectl'
alias pc='pre-commit'
alias pcr='pre-commit run'
alias pcra='pre-commit run --all-files'
alias tfv='./scripts/terraform-validate-wrapper.sh'
alias tfl='./scripts/tflint-wrapper.sh'
alias tfs='./scripts/trivy-wrapper.sh'

# Función para cambiar contextos de kubectl fácilmente
kctx() {
    if [[ $1 == "staging" ]]; then
        aws eks update-kubeconfig --region us-west-2 --name board-games-staging
    elif [[ $1 == "production" ]]; then
        aws eks update-kubeconfig --region us-west-2 --name board-games-production
    else
        echo "Uso: kctx [staging|production]"
    fi
}

# Prompt mejorado para mostrar contexto de kubectl
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(kubectl config current-context 2>/dev/null | sed "s/.*/ (\033[0;33m&\033[0m)/")\$ '
EOF

# 13. Mostrar versiones instaladas
echo ""
log_success "🎉 Entorno Codespaces configurado exitosamente!"
echo ""
echo "📊 Versiones instaladas:"
echo "  - AWS CLI: $(aws --version)"
echo "  - Terraform: $(terraform version | head -n1)"
echo "  - kubectl: $(kubectl version --client --short)"
echo "  - Pre-commit: $(~/.local/bin/pre-commit --version)"
echo "  - TFLint: $(tflint --version)"
echo "  - Trivy: $(trivy --version | head -n1)"
echo "  - Infracost: $(infracost --version)"
echo ""
echo "🚀 Comandos útiles:"
echo "  - pcra          # Ejecutar todos los pre-commit hooks"
echo "  - tfv           # Validación rápida de Terraform"
echo "  - tfl           # TFLint personalizado"
echo "  - tfs           # Trivy security scan"
echo "  - kctx staging  # Cambiar a contexto staging"
echo ""
echo "💡 Reinicia el terminal para cargar los aliases: source ~/.bashrc"
