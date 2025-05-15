#!/bin/bash
#
# Script to deploy a container image to an AWS Lambda Function
#
# REQUIRES:
#   jq (https://jqlang.github.io/jq/)
#   docker (https://docs.docker.com/desktop/) > version Docker 1.5
#   AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
#
# Command line arguments:
# [1] registry: Registry URI
# [2] repository: Name of repository to create
# [3] dockerfile: Name of dockerfile to build container for: "Dockerfile-flpe" or "Dockerfile-moi"
# [4] local: Whether script is being run locally
# 
# Example usage: ./deploy-ecr.sh "account-id.dkr.ecr.region.amazonaws.com" "container-image-name" "Dockerfile-flpe" "true"

REGISTRY=$1
REPOSITORY=$2
DOCKERFILE=$3
IS_LOCAL=$4

# Determine if repo exists
response=$(aws ecr describe-repositories --repository-names "$REPOSITORY" 2>&1)
repo=$(echo "$response" | jq '.repositories[0].repositoryName')
repo="${repo%\"}"    # Remove suffix double quote
repo="${repo#\"}"    # Remove prefix double quote

if [[ "$repo" == "$REPOSITORY" ]]; then
    echo "Repository exists: '$REPOSITORY' and will not be created."
else
    # Creat repo
    echo "Respository does not exist. Creating repository: $REPOSITORY."
    response=$(aws ecr create-repository --repository-name "$REPOSITORY" \
                --image-tag-mutability "MUTABLE" \
                --image-scanning-configuration scanOnPush=false \
                --encryption-configuration encryptionType="AES256" )

    # Test if repo was created
    status=$(echo "$response" | jq '.repository.repositoryName')
    status="${status%\"}"    # Remove suffix double quote
    status="${status#\"}"    # Remove prefix double quote
    if [[ "$status" == "$REPOSITORY" ]]; then
        echo "Repository was created."
    else
        echo "Respository could not be created."
    fi
fi

if [[ "$IS_LOCAL" == "true" ]]; then
    # Login
    docker login -u AWS https://$REGISTRY -p $(aws ecr get-login-password --region us-west-2)

    # Build
    cd ..
    docker build -t $REGISTRY/$REPOSITORY -f $DOCKERFILE .

    # Push
    docker push $REGISTRY/$REPOSITORY
    cd deploy
fi
