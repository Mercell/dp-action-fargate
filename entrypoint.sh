#!/bin/sh -l
#Script to get current task definition, and based on that add new ecr image address to old template and remove attributes that are not needed, then we send new task definition, get new revision number from output and update service
set -e
AWS_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r '.Account')
ECR_IMAGE="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
TASK_DEFINITION=$(aws ecs describe-task-definition --task-definition "$TASK_FAMILY" --region "$AWS_DEFAULT_REGION")
NEW_TASK_DEFINTIION=$(echo $TASK_DEFINITION | jq --arg IMAGE "$ECR_IMAGE" '.taskDefinition | .containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities)')
NEW_TASK_INFO=$(aws ecs register-task-definition --region "$AWS_DEFAULT_REGION" --cli-input-json "$NEW_TASK_DEFINTIION")
NEW_REVISION=$(echo $NEW_TASK_INFO | jq '.taskDefinition.revision')
aws ecs update-service --cluster ${ECS_CLUSTER} \
                       --service ${SERVICE_NAME} \
                       --task-definition ${TASK_FAMILY}:${NEW_REVISION} --force-new-deployment

# Sets imaaetag parameter. This is required for our terraform code for this service
aws ssm put-parameter --name /${SERVICE_NAME}/imagetag --type "String" --value ${IMAGE_TAG} --overwrite
