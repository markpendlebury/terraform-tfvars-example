# Terraform auto.tfvars demo
---


This demo is designed to help explain how a single terraform configuration can be deployed to multiple environments using a map to describe each environment. In this example we use `dev` and `prod` but in reality you could call them anything you like and have as many different environments as you need.


The core components of this feature are: 
- `*.auto.tfvars`
  - This file contains a map describing the variables and values for each environment we plan to deploy.
- `locals.tf`
  - This file contains a small peice of logic to help us reference the variables from each environment-specific object
- `variables.tf`
  - Here we decalre the structure of the environments as a strongly typed map of objects


# Infrastructure Goal

The purpose of the terraform configuration in this demo is to produce two files, each in their respective `environment` folder. Our target folder structure is like so: 

##### Dev
```sh
├── dev
│   └── dev.txt
```
```sh
cat dev/dev.txt
Hello from Development
```

##### Prod
```sh
├── prod
│   └── prod.txt
```
```sh
cat prod/prod.txt
Hello from Production
```


# Terraform Configuration

Starting with the environment configuration found in `example.auto.tfvars`

```hcl
environment = {
    "dev" = {
        filename = "dev.txt"
        content = "Hello from Development"
        folder = "development"
    }
    "prod" = {
        filename = "prod.txt"
        content = "Hello from Production"
        folder = "production"
    }
}
```

Here we have a map named `environment` and within that map there are two maps `dev` and `prod` each contain the same variable keys but environemnt specific values.

This values can be referenced using the local `env_config` found inside `locals.tf`

```hcl
env_config = var.environment[var.env]
```

We can use this local to reference the environment specific variables like so: 

```hcl
filename = ${local.env_config["filename"]}
```

So if our env is set to `dev` we would get `filename = "dev.txt"`


# Running the demo

With all the above in mind we can run the demo code and see it's results.

1. `terraform init`
2. `export TF_VAR_env=dev`  <-- this is how we tell terraform which variable configuration to use
3. `terraform plan` Should give an output similar to this:

```hcl
Terraform will perform the following actions:

  # local_file.this will be created
  + resource "local_file" "this" {
      + content              = "Hello from Development"
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "./development/dev.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + content  = "Hello from Development"
  + filename = "dev.txt"
  + folder   = "development"
```

4. `terraform apply` and you'll see a new folder appear in your root directory and within it, a dev.txt file

5. `export TF_VAR_env=prod`
6. `terraform plan` Will now want to destroy dev and replace it with prod since we are now running terraform against the prod variable configuration

```hcl
Terraform will perform the following actions:

  # local_file.this must be replaced
-/+ resource "local_file" "this" {
      ~ content              = "Hello from Development" -> "Hello from Production" # forces replacement
      ~ content_base64sha256 = "IOWArQCzCggjXVcdO/SP+4mnXTQJdYQYaKAz08BuTKI=" -> (known after apply)
      ~ content_base64sha512 = "gbkHaWUz6KxCq6mIEzTFp8peidY73sJDUgNfNywP6UHAsQ6plBDwqNYYbwOYpO97bndBiXFUXQiWe5u57+gM+g==" -> (known after apply)
      ~ content_md5          = "9f6c58958ac07b842430cc13842c3602" -> (known after apply)
      ~ content_sha1         = "10f7691d3ceb43003d44d9769caab34f7e92e6ee" -> (known after apply)
      ~ content_sha256       = "20e580ad00b30a08235d571d3bf48ffb89a75d340975841868a033d3c06e4ca2" -> (known after apply)
      ~ content_sha512       = "81b907696533e8ac42aba9881334c5a7ca5e89d63bdec24352035f372c0fe941c0b10ea99410f0a8d6186f0398a4ef7b6e77418971545d08967b9bb9efe80cfa" -> (known after apply)
      ~ filename             = "./development/dev.txt" -> "./production/prod.txt" # forces replacement
      ~ id                   = "10f7691d3ceb43003d44d9769caab34f7e92e6ee" -> (known after apply)
        # (2 unchanged attributes hidden)
    }

Plan: 1 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  ~ content  = "Hello from Development" -> "Hello from Production"
  ~ filename = "dev.txt" -> "prod.txt"
  ~ folder   = "development" -> "production"
```