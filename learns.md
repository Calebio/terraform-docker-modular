I normally make sure I'm conneted to my github by usin g the commands <br/>
`git config --global user.name "Caleb"`
`git config --global user.email "kalebiotezz@yahoo.com"`





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
The above code works only for datatypes of let's say strings and when working with values like ip_addresses you'll use a for loop, example below.

```
output ip-address {
  value       = [for i in docker_container.nodered_container[*]: i.ip_address]
  description = "ip address of the container"
}

```
