provider "aws" {
  region = "us-east-1"
}

#security group
resource "aws_security_group" "webserver_access" {
        name = "webserver_access"
        description = "allow ssh and http"

        ingress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        ingress {
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
        }

        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }


}
#security group end here

resource "aws_instance" "ourfirst" {
  ami = "ami-0960ab670c8bb45f3"
  availability_zone = "us-east-2b"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.webserver_access.name}"]
  /* the key zoomkey must be downloaded in your machine from where
  you are executing this code. So first create the key, download it
  and then use it */
  key_name = "sams"
  user_data = <<-EOF
        #!/bin/bash
        sudo apt update
        sudo apt install apache2 -y
        sudo systemctl start apache2
        sudo systemctl enable apache2
        echo "<h1>sample webserver using terraform</h1>" | sudo tee /var/www/html/index.html
  EOF
  tags = {
    Name  = "hello-terraform"
    Stage = "testing"
    Location = "India"
  }

}
