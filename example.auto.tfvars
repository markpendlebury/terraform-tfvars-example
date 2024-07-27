##########################################################################################################################
#                                                                                                                        #
# Scope: auto.tfvars contains variable definitions that use the same basic syntax as Terraform language files,           #
#        but consists only of variable name assignments:                                                                 #
#                                                                                                                        #
# Further reading: https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files #
#                                                                                                                        #
##########################################################################################################################


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