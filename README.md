# AWS Static Site with Terraform

This template will allow you to deploy a static website in AWS using 
Terraform Cloud. For details on how to use this repo, see this 
blog post:  

[https://codingpackets.com/blog/aws-static-website-with-terraform/](https://codingpackets.com/blog/aws-static-website-with-terraform/)

Adjust the following two files to suit your environment.

`provider.tf`
```
terraform {
  cloud {
    organization = "<ORGANIZATION>"

    workspaces {
      name = "<WORKSPACE-NAME>"
    }
  }
}
```

`terraform.tfvars`
```
project_name = "<PROJECT_NAME>"
domain_name  = "<EXAMPLE.DOMAIN>"
environment  = "<ENVIRONMENT>"
```