# DSA - IaC com Terraform, AWS, Azure e Databricks


```sh
docker build -t devops .
docker run --name devops -it --rm -v ./shared:/shared devops /bin/bash
```

### AWS Cli

```sh
aws configure
```

```sh
aws s3 ls | awk '{print $NF}'
```

### Terraform

- https://github.com/hashicorp/hcl
- https://developer.hashicorp.com/terraform/intro/core-workflow

```sh
terraform init
```

```sh
terraform plan -var 'instance_type=t2.micro' -var 'ami=ami-0a0d9cf81c479446a' -out lab2-plan.txt
```

```sh
terraform apply --auto-approve
terraform apply -var-file="variaveis.tfvars"
```

```sh
terraform output
```

```sh
terraform destroy --auto-approve
terraform destroy -var-file="variaveis.tfvars"
```

```sh
terraform graph
```

## References

- https://www.xcubelabs.com/blog/gitops-explained-a-comprehensive-guide/