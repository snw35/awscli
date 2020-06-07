# awscli

Automatically-updated AWS CLI container.

Always contains the most recent version of the AWS CLI from https://github.com/aws/aws-cli/releases

## How to use

This container simply uses the 'aws' command as it's entrypoint, so it can be run with any arguments passed directly:
```
docker run -it --rm snw35/awscli --help
```
