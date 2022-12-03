# output "ip-address" {
#   value       = flatten(module.container[*].ip-address)
#   description = "ip address of the container"
# }

# output "container-name" {
#   value       = module.container[*].container-name
#   description = "Name of the container"
# }

output "application_access" {
  value = {for x in docker_container.app_container[*]: x.name => join(":", [x.ip_address], x.ports[*]["external"])}
}