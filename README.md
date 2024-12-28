## ECS Demo

Spring Boot project to demonstrate ECS Container usage

### IaC

##### terraform localstack

```shell
tflocal init
tflocal plan -var-file variables.tfvars
tflocal apply -var-file variables.tfvars -auto-approve
tflocal output
tflocal destroy -var-file variables.tfvars -auto-approve
```

##### terraform aws

```shell
terraform init
terraform plan -var-file variables.tfvars
terraform apply -var-file variables.tfvars -auto-approve
terraform output
terraform destroy -var-file variables.tfvars -auto-approve
```

##### docker build

```shell
#docker build -t ecsdemo-app .
docker compose build
```

##### docker push to localstack

```shell
docker tag ecsdemo-app:latest 000000000000.dkr.ecr.us-west-2.localhost.localstack.cloud:4566/ecsdemo-dev:latest
docker push 000000000000.dkr.ecr.us-west-2.localhost.localstack.cloud:4566/ecsdemo-dev:latest
#docker pull 000000000000.dkr.ecr.us-west-2.localhost.localstack.cloud:4566/ecsdemo-dev:latest
```

##### docker to aws

```shell
docker tag ecsdemo-app:latest 714681258665.dkr.ecr.us-west-2.amazonaws.com/ecsdemo-dev:latest
docker push 714681258665.dkr.ecr.us-west-2.amazonaws.com/ecsdemo-dev:latest
#docker pull 714681258665.dkr.ecr.us-west-2.amazonaws.com/ecsdemo-dev:latest
```
