#!/bin/sh

# ecr repo
aws ecr list-images --repository-name ecsdemo-dev
aws ecr batch-delete-image --repository-name ecsdemo-dev --image-ids imageTag=latest

# ecs cluster
aws ecs list-clusters
aws ecs describe-clusters --clusters ecsdemo-dev

# ecs task definition
aws ecs list-task-definitions

# ecs service
aws ecs list-services

# alb
aws elbv2 describe-load-balancers
aws elbv2 describe-target-groups
aws elbv2 describe-listeners --load-balancer-arn arn:aws:elasticloadbalancing:us-west-2:714681258665:loadbalancer/app/ecsdemo-dev/7bc8d4e1a1dbab36

# acm
aws acm list-certificates

# https://medium.com/boltops/gentle-introduction-to-how-aws-ecs-works-with-example-tutorial-cea3d27ce63d
aws ec2 create-security-group --group-name my-ecs-sg --description my-ecs-sg
aws ecs register-task-definition --cli-input-json file://task-definition.json
aws ec2 authorize-security-group-ingress --group-name my-ecs-sg --protocol tcp --port 1-65535 --source-group my-elb-sg
aws ecs create-service --cli-input-json file://ecs-service.json
