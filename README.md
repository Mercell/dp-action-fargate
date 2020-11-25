# Mercell/dp-action-fargate
It is difficult to update the docker image in a Task Definition for a Fargate service.
The problem is described in this [issue](https://github.com/aws/aws-cli/issues/3064)

This action is based on some of the solutions described in the issue above. 

## Todo
- refactor environment variables
- ... 

## Usage
Depends on action FranzDiebold/github-env-vars-action to set the $GITHUB_SHA_SHORT 

## Example 

Set imagetag parameter in AWS Parameter Store

      - name: Update parameter store
        uses: Mercell/dp-action-fargate@v1
        with:
          entrypoint: /setparam.sh
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: "eu-central-1"
          SERVICE_NAME: "message-logger"

Upgrades task definition and reloads the service

      - name: Set github env-vars
        uses: FranzDiebold/github-env-vars-action@v1.2.1
      - name: Update fargate
        uses: Mercell/dp-action-fargate@v1
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: "eu-central-1"
          IMAGE_REPO_NAME: "hello-world"
          IMAGE_TAG: $GITHUB_SHA_SHORT
          TASK_FAMILY: "Dev-DistAndPres-hello-service"
          ECS_CLUSTER: "Dev-DistAndPres"
          SERVICE_NAME: "HelloService"  