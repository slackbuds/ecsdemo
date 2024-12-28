# init AWS
source awsmlops.sh local
aws sts get-caller-identity

# ecr repo
aws ecr list-images --repository-name ecsdemo-dev

# ecs cluster
aws ecs list-clusters
aws ecs describe-clusters --clusters ecsdemo-dev

# ecs task definition

# ecs service

# elb

# elb sg

# lb target group

# ecs sg
