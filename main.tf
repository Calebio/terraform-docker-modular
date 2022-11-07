terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}


provider "docker" {}

# download nodered image

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

# Generate random strings

resource "random_string" "string_rand" {
  count = 2
  length  = 5
  upper = false
  special = false
}


# Create the container

resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-", ["nodered", random_string.string_rand[count.index].result]) # this right here was used to reference the random strings and carve out a name for the container
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}


output ip-address {
  value       = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address], i.ports[*]["external"])]
  description = "ip address of the container"
}

output container-name {
  value       = docker_container.nodered_container[*].name
  description = "Name of the container"
}


# output ip-address-cont-2 {
#   value       = join(":", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[1].ports[0].external])
#   description = "ip address of the container"
# }


