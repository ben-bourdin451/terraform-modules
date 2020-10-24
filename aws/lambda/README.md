# Lambda Module

Use this module to provision Lambda functions and specify log retention.

## Gotchas

Below are a list of things that differ from the traditional [Terraform Lambda resource](https://www.terraform.io/docs/providers/aws/r/lambda_function.html)

### Publishing new versions

At the moment this module does not publish new versions of the Lambda function on each configuration change however this is something that can be managed by this module in the future.

### Optional resource blocks

This module does not support the following 'optional' attributes:

*   Reserved concurrent executions
*   Dead letter config
