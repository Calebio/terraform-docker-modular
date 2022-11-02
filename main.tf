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

# start t he container

resource "docker_container" "nodered_container" {
  name  = "nodered"
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    external = 1880
  }
}

output ip-address {
  value       = docker_container.nodered_container.ip_address
  description = "ip address of the container"
}

output container-name {
  value       = docker_container.nodered_container.name
  description = "Name of the container"
}
