# Notes for Terraform _Provision_

Provision is used to perform configuration tasks after a resource is created or modified. It's mainly for setting up
system environments or applications on resources managed by Terraform.

## Key Concepts

- Provisioners allow executing scripts or commands during different stages of resource's lifecycle.
- Commonly used provisioners:
    - `remote-exec`: Executes commands on a remote machine.
    - `local-exec`: Executes commands on the machine running Terraform.
    - `file`： Copies files or directories to a remote machine.

## Use Cases

- **Configuring instances**: For example, installing software or starting services after an EC2 instance is created.
- **Environment**: Transferring files or configuring remote environments.
- **Debugging**: Temporarily used for testing or troubleshooting resource creation workflows.

## HCL Example

```hcl
resource "aws_instance" "example" {
  ami = "ami-1234"
  instance_type = "t2.micro"
  
  # Upload a file to the remote instance 
  provisioner "file" {
    source = "path/to/local/file"
    destination = "/tmp/remote-file"
  }
  
  # Execute commands on the remote instance 
  provisioner "remote-exec" {
    inline = [
        "sudo apt-get update",
        "sudo apt-get install -y nginx"
    ]
  }
  
}
```