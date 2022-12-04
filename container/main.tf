resource "random_string" "string_rand" {
  count   = var.count_in
  length  = 5
  upper   = false
  special = false
}


# Create the container

resource "docker_container" "app_container" {
  count = var.count_in
  name  = join("-", [var.name_in, terraform.workspace, random_string.string_rand[count.index].result])
  image = var.image_in
  ports {
    internal = var.int_port_in
    external = var.ext_port_in[count.index]
  }

  dynamic "volumes" {
    for_each = var.volumes_in
    content{
      container_path = volumes.value["container_path_each"]
    volume_name    = docker_volume.container_volume[volumes.key].name
    }
  }
  provisioner "local-exec" {
    when       = destroy
    command    = "echo ${self.name}: ${self.ip_address}:${join("", [for x in self.ports[*]["external"] : x])} >> containers.txt"
    on_failure = fail
  }
  provisioner "local-exec" {
    when       = destroy
    command    = "rm -f container.txt"
    on_failure = fail
  }
}

resource "docker_volume" "container_volume" {
  count = length(var.volumes_in)
  name  = "${var.name_in}-${count.index}-volume"
  lifecycle {
    prevent_destroy = false
  }
  provisioner "local-exec" {
    when       = destroy
    command    = "mkdir ${path.cwd}/../backup"
    on_failure = continue
  }
  provisioner "local-exec" {
    when       = destroy
    command    = "sudo tar -czvf ${path.cwd}/../backup/${self.name}.tar.gz ${self.mountpoint}/"
    on_failure = fail
  }
}