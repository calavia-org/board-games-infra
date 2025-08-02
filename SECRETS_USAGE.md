# Gestión segura de contraseñas y rotación automática en EKS con AWS Secrets Manager y Reloader

Este documento describe cómo gestionar de forma segura las credenciales de bases de datos en AWS EKS usando AWS Secrets Manager, el CSI Driver de Secrets Store y Reloader para reinicio automático de pods tras la rotación de secretos.

---

## 1. Almacenamiento seguro de credenciales en AWS Secrets Manager

Crea el secreto en AWS Secrets Manager para producción o staging:

```bash
aws secretsmanager create-secret \
  --name calavia/production/db_credentials \
  --secret-string '{"username":"admin","password":"contraseña_inicial"}'
```

Puedes activar la rotación automática desde la consola de AWS, asociando una Lambda de rotación para tu motor de base de datos (por ejemplo, PostgreSQL).

---

## 2. Acceso al secreto desde Terraform

En tu `main.tf` de Terraform, accede al secreto:

```hcl
data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = "calavia/production/db_credentials"
}
```

Y úsalo en el recurso de base de datos:

```hcl
resource "aws_db_instance" "calavia_postgres" {
  # ...otros argumentos...
  username = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)["password"]
  # ...otros argumentos...
}
```

---

## 3. Permitir acceso a los pods de EKS al secreto

### a) Crea un IAM Role for Service Account (IRSA)

Define un rol IAM y asígnalo al ServiceAccount de tu aplicación para permitir acceso a Secrets Manager.

### b) Crea el ServiceAccount en Kubernetes

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<TU_AWS_ACCOUNT_ID>:role/calavia-app-sa-role-production
```

---

## 4. Montar el secreto como variable de entorno en los pods

### a) Instala el Secrets Store CSI Driver

Sigue la [guía oficial](https://secrets-store-csi-driver.sigs.k8s.io/getting-started/installation.html).

### b) Crea un SecretProviderClass

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: db-credentials
  namespace: default
spec:
  provider: aws
  parameters:
    objects: |
      - objectName: "calavia/production/db_credentials"
        objectType: "secretsmanager"
  secretObjects:
    - secretName: db-credentials
      type: Opaque
      data:
        - objectName: username
          key: username
        - objectName: password
          key: password
```

### c) Usa el secreto como variable de entorno en tu Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  annotations:
    reloader.stakater.com/auto: "true"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      serviceAccountName: app-sa
      containers:
        - name: app
          image: tu-imagen:latest
          env:
            - name: DB_USERNAME
              valueFrom:
                secretKeyRef:
                  name: db-credentials
                  key: username
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: db-credentials
                  key: password
          volumeMounts:
            - name: secrets-store
              mountPath: "/mnt/secrets-store"
              readOnly: true
      volumes:
        - name: secrets-store
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: "db-credentials"
```

---

## 5. Instalación y uso de Reloader

Instala Reloader para reiniciar automáticamente los pods cuando cambie el secreto:

```bash
kubectl apply -f https://github.com/stakater/Reloader/releases/latest/download/reloader.yaml
```

Asegúrate de que tu Deployment tiene la anotación:

```yaml
metadata:
  annotations:
    reloader.stakater.com/auto: "true"
```

---

## 6. Flujo de rotación y actualización

1. El secreto se rota en AWS Secrets Manager (manual o automático).
2. El CSI Driver actualiza el Secret de Kubernetes.
3. Reloader detecta el cambio y reinicia los pods afectados.
4. Los contenedores arrancan con las nuevas variables de entorno.

---

## 7. Variables sensibles en Terraform

En tu `variables.tf`, marca las variables sensibles como `sensitive = true` y no les asignes valores por defecto:

```hcl
variable "db_password" {
  description = "Contraseña para la base de datos"
  type        = string
  sensitive   = true
}
```

---

## Referencias

- [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html)
- [Secrets Store CSI Driver](https://secrets-store-csi-driver.sigs.k8s.io/)
-
