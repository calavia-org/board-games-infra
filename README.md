# board-games-infra
Manage infrastructure to run game server

## Setup instructions

```promptql

Como ingeniero de infraestructura, quiero implementar el código para desplegar la infraestructura basada en kubernetes que me permita alojar un servicio de genración de partidas distribuidas multi jugador en tiempo real. Debe estar definida en Terraform y el objetivo del despliegue es un Clúster EKS en AWS con maquinas spot que sirva para controlar el estado dos entornos: staging y producción. Además se debe utiliza el servicio Terraform Cloud para almacenar el estado.

Para la persistencia se requiere provisionar un servicio gestionado tipo Redis para caché y un servicio gestionado tipo PostgreSQL, los cuales solamente deben ser accesibles desde el cluster de aplicaciones definido anteriormente. Para la gestion de las credenciales de uso de los servicios gestionados se debe integrar algun mecanismo de actualización de secretos en el cluster, implementando ademas un rotado automático mensual de las contraseñas. La solución requerida es IAM Service Account (IMSA) AWS Secrets Manager

El clúster se debe desplegar en tres zonas de disponibilidad parametrizables y con requisitos fuertes de seguridad, impidiendo los accesos no autorizados desde el exterior del mismo. Además el cluster debe estar monitorizado y con alertado basado en kube-prometheus stack con el Alert Manager con 3 días de retención de información para el entorno de producción y de un día para el entorno de stagging. Al necesitar el acceso para un único usuario también quiero incluir AWS Managed Grafana para visualizar los datos de modo que también quiero un conjunto de dashboards que me permitan visualizar los datos que proveé el stack kube-prometheus.

Como requisito de seguridad, se requiere implementar políticas de seguridad fuertes dentro de la red interna del cluster. También es obligatorio que el clúster disponga de un proveedor de certificados gratuito, que me permita que cada vez que despliegue una aplicación con un Ingress Controler basado en AWS ALB , se registre en el servicio de DNS de AWS (Route 53) el FQDN y se provisione un certificado valido con auto renovación y con un Cluster Issuer para Let’s Encrypt + DNS-01 challenge haciendo uso ademas de External DNS. Por tanto tambíén necesito el codigo necesario para configurar toda esta funcionalidad, incluida la configuración inicial del servicio DNS y las demás piezas mencionadas

```
