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
  count = var.container_count
  length  = 5
  upper = false
  special = false
}


# Create the container

resource "docker_container" "nodered_container" {
  count = var.container_count
  name  = join("-", ["nodered", random_string.string_rand[count.index].result]) # this right here was used to reference the random strings and carve out a name for the container
  image = docker_image.nodered_image.latest
  ports {
    internal = var.intern_port
    # external = 1880
  }
}


