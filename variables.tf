##########################################################################################################
#                                                                                                        #
# Scope: Variables allow customization of the infrastructure                                             #
#                                                                                                        #
# Further reading: https://www.terraform.io/docs/configuration/variables.html                            #
#                                                                                                        #
##########################################################################################################

variable "env" {
  description = "The environment of the organization"
  type        = string
}

variable "environment" {
  description = "The environment specific terraform config"
  type = map(object({
    # insert any environment specific variables here
    filename = string
    content = string
    folder = string
  }))
}