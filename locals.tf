##########################################################################################################
#                                                                                                        #
# Scope: A local value assigns a name to an expression, so you can use the name multiple times           #
#  within config instead of repeating the expression.                                                    #
#                                                                                                        #
# Further reading: https://developer.hashicorp.com/terraform/language/values/locals                      #
#                                                                                                        #
##########################################################################################################

locals {
    env_config = var.environment[var.env]
}
