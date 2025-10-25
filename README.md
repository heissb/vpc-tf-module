# Terraform AWS VPC Module

This terraform module creates a VPC with public and private subnets, internet gateway, NAT gateway, and SSM and S3 endpoints.

## Testing the plan

To set debug logging:

```bash
export TF_LOG=DEBUG 
terraform plan
```

Log Levels
You can set different verbosity levels:
```
TRACE - Most verbose
DEBUG - Detailed debugging info
INFO - General informational messages
WARN - Warning messages only
ERROR - Error messages only
```

To export the plan to a file (Linux/Mac):

```bash
terraform plan | tee plan-output.txt
```

or basic redirect:

```bash
terraform plan > plan-output.txt
```
