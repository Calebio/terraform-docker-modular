# download nodered image
resource "docker_image" "nodered_image" {
  name = var.image_in

}