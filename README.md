# aws-technical-essentials-tf

Terraform configuration for Employee Directory Application example in [AWS Technical Essentials](https://explore.skillbuilder.aws/learn/course/external/view/elearning/1851/aws-technical-essentials)

## Quick Start

```bash
cd assets/
terraform init
terraform plan
terraform apply
```

## Variables

| Variable | Default value |
| --- | --- |
| `region` | `ap-east-1` |
| `instance_type` | `t3.micro` |
| `email` | `john.doe@example.com` |

## Supported regions

`ap-east-1`, `us-west-2`

## Known issues

Employee mugshots don't display correctly in `ap-east-1` region due to `IllegalLocationConstraintException`, possibly due to the way the app is written - see the links below for details:

- https://stackoverflow.com/questions/58143279/aws-cli-aws-s3-presign-does-not-work-for-ap-east-1-hong-kong-region-locatio
- https://github.com/boto/boto3/issues/2098

## License

[Apache 2.0](./LICENSE)
