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
#docker build --platform linux/amd64 -t ecsdemo-app .
docker compose build
```

##### docker push to localstack

```shell
docker tag ecsdemo-app:latest 000000000000.dkr.ecr.us-west-2.localhost.localstack.cloud:4566/ecsdemo-dev:latest
docker push 000000000000.dkr.ecr.us-west-2.localhost.localstack.cloud:4566/ecsdemo-dev:latest
```

##### docker to aws

```shell
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 714681258665.dkr.ecr.us-west-2.amazonaws.com
docker tag ecsdemo-app:latest 714681258665.dkr.ecr.us-west-2.amazonaws.com/ecsdemo-dev:latest
docker push 714681258665.dkr.ecr.us-west-2.amazonaws.com/ecsdemo-dev:latest
```

### Endpoints

* https://ecsdemo.slackbuds.io/actuator
* https://ecsdemo.slackbuds.io/api/v1/hello
* https://ecsdemo.slackbuds.io/api/v1/env
* https://ecsdemo.slackbuds.io/api/v1/echo
* https://ecsdemo.slackbuds.io/api/v1/tables
