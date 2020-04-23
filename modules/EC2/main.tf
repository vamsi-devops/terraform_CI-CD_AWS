resource "aws_security_group" "my_sg" {
    name            = "my_sg"
    description     = "created from terraform"
    ingress{
        cidr_blocks = ["0.0.0.0/0"]
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
    }
    egress{
        cidr_blocks = ["0.0.0.0/0"]
        protocol    = "-1"
        from_port   = "0"
        to_port     = "0"
    }
    tags = {
        Name = "openmrs"
    }
}
resource "aws_instance" "web1" {
   ami                         = "ami-07f4cb4629342979c"
    instance_type               = "t2.micro"
    #subnet_id                   = "${aws_subnet.subnet_1.id}"
    #associate_public_ip_address = true
    vpc_security_group_ids      = [ "${aws_security_group.my_sg.id}" ]
    #key_name                    = "${var.awskeypair}"

    key_name                    = "aws-eks"
    tags = {
        Name = "openmrs",
        "agent" = "one"
    }


provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
	"chmod +x /tmp/script.sh",
      "/bin/bash /tmp/script.sh"
    ]  
  }
  
   provisioner "local-exec" {
    command = "chmod +x /tmp/script.sh; /bin/bash /tmp/script.sh"
  }
  
  
 timeouts {

     create = "120m"
 }
}




