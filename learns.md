## Things I learned on this docker project.

`curl http://169.254.169.254/latest/meta-data/public-ipv4` ==> I used this code to get the ip of a docker node/containerfter 

To run the docker image in a browser, input the ip address shown a running the about curl command and add the port number which my was 1880.

- I used jq to see the state of the terraform resources. To install jq use this command `sudo apt install jq` and then to show the state of terraform resources after a terraform apply use the command `terraform show -json | jq`.

- To pick out specific informations from a terraform state: for instance you want to pick out ip addresses out, you can use this command `terraform show | grep ip` or to pick out names `terraform show | grep name`.

- Output is used to customize the infomations show after an apply. for example 
```
output ip-address {
  value       = docker_container.nodered_container.ip_address
  description = "ip address of the container"
} 

````

- To show an output use the command `terraform output`

- Learned about the `join` and it can be used to join strings with numbers and indexed array of charracters.

- I learned about the **random_string** resource and how it was used with `join` to add a unique character to the name of a resource. 
example below <br/>
```
resource "docker_container" "nodered_container" {
  name  = join("-", ["nodered", random_string.string_rand.result]) # this right here was used to reference the random strings and carve out a name for the container
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}

```
- Here's what the result looked like `container-name = "nodered-zh3yg"`

- I learned about count and it is used to create multiple of the same resource example is: <br/>
```
resource "random_string" "string_rand" {
  count = 2      //This is used to create 2 random strings that will be later used.
  length  = 5
  upper = false
  special = false
}
```

**Keep in mind that when using count, you will always have an index, so you can't reference just the resource anymore and resource name you do need to add that index.**


- To make reference to the created random strings below is an example. <br/>
```
resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-", ["nodered", random_string.string_rand[count.index].result]) # this right here was used to reference the random strings and carve out a name for the container
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
}
```

- Splat(*) is used to get everything in a list or array. <br/>
I learned to use splat in a single output to generate multiple values.
```
output container-name {
  value       = docker_container.nodered_container[*].name
  description = "Name of the container"
}
```

Here we used join with the for loop to get an output of ip address and port, below is an example <br/>
```
output ip-address {
  value       = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address], i.ports[*]["external"])]
  description = "ip address of the container"
}
```

- Terraform import! 
Today I learned about terraform import and why you need terraform import.

We created a problem: In our `main.tf` file we specified in the count that we wanted only 1 container and then we split terminal and on the first terminal we ran `terraform apply -auto-approve lock=false` and simutaniously we ran `terraform apply -auto-approve` to defile what we specified in the `main.tf` file thereby break the tfstatefile. 

This created a problem: 
1. Docker could has 2 containers but terraform could read only 1
2. Terraform won't be able to destroy the resources because there's a conflict between the terraform state file and docker container.

The solution to this problem is: Import the other container from docker and we used the following steps to do it. 
1. Create the resource in the `main.tf` file <br/>
```
resource "docker_container" "nodered_container2"{
  name = "<container name>"
  image = docker_image.nodered_image.latest
}
```

2. Get the docker_container ID with docker inspect `docker inspect --format="{{.ID}}" = <container name>`
3. User terraform import command + a bash command to import the container to terraform `terraform import docker_container.nodered_container2 $(docker inspect --format="{{.ID}}" = <container name>)`

- Variable validation : This means adding conditions to a variable, this ensures that the conditions are met and the variables carry the right value.

