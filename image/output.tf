output image_out {
  value       = docker_image.nodered_image.latest
  description = "docker image output to be consumed by the root module"
}
