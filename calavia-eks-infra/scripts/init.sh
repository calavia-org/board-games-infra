#!/bin/bash

# Script de inicialización para el entorno de Calavia Games

# Configuración de variables de entorno
export AWS_REGION="us-west-2"
export CLUSTER_NAME="calavia-eks-cluster"
export NODE_TYPE="t3.medium"
export NODE_COUNT=3
export SPOT_INSTANCES=true

# Inicializar Terraform
terraform init

# Aplicar configuración de Terraform
terraform apply -auto-approve

# Configurar kubectl
aws eks --region $AWS_REGION update-kubeconfig --name $CLUSTER_NAME

# Desplegar aplicaciones necesarias
kubectl apply -f ./k8s/redis-deployment.yaml
kubectl apply -f ./k8s/postgres-deployment.yaml
kubectl apply -f ./k8s/monitoring-deployment.yaml

echo "Inicialización completada."