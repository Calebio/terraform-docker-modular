output "ip-address" {
  value       = flatten(module.container[*].ip-address)
  description = "ip address of the container"
}

output "container-name" {
  value       = module.container[*].container-name
  description = "Name of the container"
}