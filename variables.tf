variable "intern_port" {
  type      = number

  validation {
    condition     = var.intern_port == 1880
    error_message = "the internal port must be 1880"
  }
}

variable "container_count" {
  type    = number
  default = 1

  validation {
    condition     = var.container_count <= 10 && var.container_count > 0
    error_message = "Each user must not create more than 10 resources(containers) on the development server. Please contact admin."
  }
}
