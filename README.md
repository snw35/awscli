# awscli

* [Travis CI: ![Build Status](https://travis-ci.org/snw35/awscli.svg?branch=master)](https://travis-ci.org/snw35/awscli)
* [Dockerhub: snw35/awscli](https://hub.docker.com/r/snw35/awscli)

Automatically-updated AWS CLI container.

Always contains the most recent version of the AWS CLI from https://github.com/aws/aws-cli/releases

## How to use

The container uses the 'aws' command as it's default entrypoint:
```
docker run -it --rm snw35/awscli
```
You will need to specify the 'aws' command when passing arguments directly:
```
docker run -it --rm snw35/awscli aws kinesis
```
