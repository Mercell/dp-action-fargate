#!/bin/sh -l
#Script to get current task definition, and based on that add new ecr image address to old template and remove attributes that are not needed, then we send new task definition, get new revision number from output and update service
IMAGE_REPO_NAME=hello-world
CODEBUILD_RESOLVED_SOURCE_VERSION=1ea12a0e
TASK_FAMILY=Dev-DistAndPres-hello-service
ECS_CLUSTER=Dev-DistAndPres
SERVICE_NAME=HelloService

set -e
AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
echo $AWS_ACCOUNT_ID
ECR_IMAGE="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${CODEBUILD_RESOLVED_SOURCE_VERSION}"
TASK_DEFINITION=$(aws ecs describe-task-definition --task-definition "$TASK_FAMILY" --region "$AWS_DEFAULT_REGION")
NEW_TASK_DEFINTIION=$(echo $TASK_DEFINITION | jq --arg IMAGE "$ECR_IMAGE" '.taskDefinition | .containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities)')
NEW_TASK_INFO=$(aws ecs register-task-definition --region "$AWS_DEFAULT_REGION" --cli-input-json "$NEW_TASK_DEFINTIION")
NEW_REVISION=$(echo $NEW_TASK_INFO | jq '.taskDefinition.revision')
echo $NEW_TASK_DEFINTIION
aws ecs update-service --cluster ${ECS_CLUSTER} \
                       --service ${SERVICE_NAME} \
                       --task-definition ${TASK_FAMILY}:${NEW_REVISION}