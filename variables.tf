variable "env"{
  type = string
  default = "dev"
  description = "Env to depoly to "
}

variable "image"{
   type = map
   description = "image for container"

   default = {
    dev = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
   }
}

variable "intern_port" {
  type      = number

  validation {
    condition     = var.intern_port == 1880
    error_message = "the internal port must be 1880"
  }
}

variable "ext_port"{
  type = map

  validation {
    condition     = min(var.ext_port["dev"]...) >= 1980 && max(var.ext_port["dev"]...) <= 65535
    error_message = "The external port must be in the valid port range for dev environment."
  }

  validation {
    condition     = min(var.ext_port["prod"]...) >= 1880 && max(var.ext_port["prod"]...) < 1980
    error_message = "The external port must be in the valid port for prod environment."
  }
}


locals {
  container_count = length(lookup(var.ext_port, var.env))
}


# variable "container_count" {
#   type    = number
#   default = 1

#   validation {
#     condition     = var.container_count <= 10 && var.container_count > 0
#     error_message = "Each user must not create more than 10 resources(containers) on the development server. Please contact admin."
#   }
# }
