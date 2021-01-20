# Container image that runs your code
FROM amazon/aws-cli:2.1.19

RUN yum install -y jq
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY setparam.sh /setparam.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]