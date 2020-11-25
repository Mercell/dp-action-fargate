#!/bin/sh -l
# Sets imaaetag parameter. This is required for our terraform code for this service
aws ssm put-parameter --name /${SERVICE_NAME}/imagetag --type "String" --value ${GITHUB_SHA_SHORT} --overwrite
