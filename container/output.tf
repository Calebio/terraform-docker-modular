# output "ip-address" {
#   value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
#   description = "ip address of the container"
# }

# output "container-name" {
#   value       = docker_container.nodered_container.name
#   description = "Name of the container"
# }

output "application_access" {
  value = { for x in docker_container.app_container[*] : x.name => join(":", [x.ip_address], x.ports[*]["external"]) }
}