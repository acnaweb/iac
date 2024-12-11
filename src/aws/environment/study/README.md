# Study Env

```sh
terraform plan -var-file="secrets.tfvars"
```

```sh
terraform apply -var-file="secrets.tfvars"
```

```sh
terraform apply -target=module.security-group -var-file="secrets.tfvars"
```

```sh
terraform destroy -var-file="secrets.tfvars"
```

```sh
terraform import -var-file="secrets.tfvars" aws_s3_bucket.marketmining-public marketmining-public
```

```sh
terraform refresh -var-file="secrets.tfvars"
terraform output
```

