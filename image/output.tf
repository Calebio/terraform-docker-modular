output image_out {
  value       = docker_image.container_image.latest
  description = "docker image output to be consumed by the root module"
}
