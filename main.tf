terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}


provider "docker" {}

# Adding persistence to the containers
resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
  }
}

# download nodered image
resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

# Generate random strings

resource "random_string" "string_rand" {
  count   = local.container_count
  length  = 5
  upper   = false
  special = false
}


# Create the container

resource "docker_container" "nodered_container" {
  count = local.container_count
  name  = join("-", ["nodered", random_string.string_rand[count.index].result]) # this right here was used to reference the random strings and carve out a name for the container
  image = docker_image.nodered_image.latest
  ports {
    internal = var.intern_port
    external = var.ext_port[count.index]
  }

  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/noderedvol" # this line was used to dynamically grab the path and point to it.. So on a case of change the deployment won't break
  }
}


