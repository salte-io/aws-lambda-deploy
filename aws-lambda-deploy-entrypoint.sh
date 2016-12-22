#!/bin/bash
set -eo pipefail

#------------------------------------------------------------------------------
# Required Environment Variables
#------------------------------------------------------------------------------
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION
# AWS_LAMBDA_FUNCTION_NAME
# AWS_LAMBDA_FUNCTION_DESCRIPTION
# AWS_LAMBDA_RUNTIME
# AWS_LAMBDA_HANDLER_NAME
# AWS_ROLE_ARN

# Restore Node Production Dependencies
npm install --production

# Package the Lambda Function
zip -r lambda.zip *

# Deploy the Lambda Function
DEPLOYED=$(aws lambda list-functions|grep FunctionName|grep $AWS_LAMBDA_FUNCTION_NAME)
if [ -z $DEPLOYED ]; then
  echo "Creating $AWS_LAMBDA_FUNCTION_NAME..."
  aws lambda create-function --function-name $AWS_LAMBDA_FUNCTION_NAME --runtime $AWS_LAMBDA_RUNTIME --role $AWS_ROLE_ARN --handler $AWS_LAMBDA_HANDLER_NAME --description $AWS_LAMBDA_FUNCTION_DESCRIPTION --zip-file lambda.zip --publish
else
  echo "Updating $AWS_LAMBDA_FUNCTION_NAME..."
  aws lambda update-function-code --function-name $AWS_LAMBDA_FUNCTION_NAME --zip-file lambda.zip --publish
fi

ARN=$(aws lambda list-functions|grep FunctionArn|grep $AWS_LAMBDA_FUNCTION_NAME|tr -d '",')
if [ -z $ARN ]; then
  echo "Unable to create the $AWS_LAMBDA_FUNCTION_NAME Lambda function!";
else
  echo "Successfully created/updated the $AWS_LAMBDA_FUNCTION_NAME Lambda Function: $ARN"
fi
