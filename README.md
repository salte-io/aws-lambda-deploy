# aws-lambda-deploy

## Description

Creates an environment containing both the AWS CLI as well as the AWS Elastic Beanstalk CLI.  It bears its name because its first use was to deploy AWS Lambda functions.  However, it can be used to interact with any AWS resources that are supported through one of the aforementioned CLIs.

## Instructions

There are two primary use cases that this image was created to support.
1. For use within a Gitlab CI YAML file.
2. For use by an interactive user.

The following are simple examples of each use case.

### _.gitlab-ci.yml File Example_

```yml
image: salte/aws-lambda-deploy:latest

variables:
  AWS_ACCESS_KEY_ID: "ABCDEFGHIJKLMNOPQRST"              
  AWS_SECRET_ACCESS_KEY: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcd"
  AWS_DEFAULT_REGION: "us-east-1"
  NAME: "MyFunction"
  RUNTIME: "nodejs4.3"
  ROLE: "arn:aws:iam::000000000000:role/xxxxx"
  HANDLER: "index.handler"
  FILE: "fileb://MyPackage.zip"

stages:
 - deploy

.deploy_template: &deploy
  stage: deploy
  script:
    - aws lambda create-function --function-name $NAME --runtime $RUNTIME --role $ROLE --handler $HANDLER --zip-file $FILE --publish

deploy:master:
  <<: *deploy
  stage: deploy
  only:
    - master
```

### _AWS Interactive Example_

```sh
$ docker run -it salte/aws-lambda-deploy sh
/ # aws help
NAME
  aws -

DESCRIPTION
  The AWS Command Line Interface is a unified tool to manage your AWS
  services.

SYNOPSIS
  aws [options] <command> <subcommand> [parameters]

  Use aws command help for information on a specific command.  Use aws
  help topics to view a list of available help topics. The synopsis for
  each command shows its parameters and their usage. Optional parameters
  are shown in square brackets.
...
```

### _EB Interactive Example_

```sh
$ docker run -it salte/aws-lambda-deploy sh
/ # eb --help
usage: eb (sub-commands ...) [options ...] {arguments ...}

Welcome to the Elastic Beanstalk Command Line Interface (EB CLI). 
For more information on a specific command, type "eb {cmd} --help".

commands:
  abort        Cancels an environment update or deployment.
  appversion   Listing and managing application versions
  clone        Clones an environment.
    ...
```
