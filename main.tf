
# Adding persistence to the containers
resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
  }
}

module "image" {
  source = "./image"
  image_in = var.image[terraform.workspace]
}

# Generate random strings

resource "random_string" "string_rand" {
  count   = local.container_count
  length  = 5
  upper   = false
  special = false
}


# Create the container module

module "container" {
  source = "./container"
  depends_on = [null_resource.dockervol]
  count = local.container_count
  name_in  = join("-", ["nodered", terraform.workspace, random_string.string_rand[count.index].result]) # this right here was used to reference the random strings and carve out a name for the container
  image_in = module.image.image_out
  int_port_in = var.intern_port
  ext_port_in = var.ext_port[terraform.workspace][count.index]
  container_path_in = "/data"
  host_path_in      = "${path.cwd}/noderedvol" # this line was used to dynamically grab the path and point to it.. So on a case of change the deployment won't break
}


