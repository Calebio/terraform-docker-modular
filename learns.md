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