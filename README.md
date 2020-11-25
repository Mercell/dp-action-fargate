# fargate-action

This action is based on this issue https://github.com/aws/aws-cli/issues/3064


## Inputs

### `who-to-greet`

**Required** The name of the person to greet. Default `"World"`.

## Outputs

### `time`

The time we greeted you.

## Example usage

      - name: Update fargate
        uses: stigmelling/fargate-action@v1
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_DEFAULT_REGION: "eu-central-1"
          IMAGE_REPO_NAME: "hello-world"
          IMAGE_TAG: $GITHUB_SHA_SHORT
          TASK_FAMILY: "Dev-DistAndPres-hello-service"
          ECS_CLUSTER: "Dev-DistAndPres"
          SERVICE_NAME: "HelloService"  