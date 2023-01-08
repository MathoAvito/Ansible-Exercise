provider "aws" {
  region = "eu-west-3"
}

data "aws_availability_zones" "available" {}

/* data "aws_ec2_instance_state" "instance_status" {
  instance_id = aws_instance.ansible_master.id
} */



locals {
  azs = data.aws_availability_zones.available.names
  /* instance_status = data.aws_ec2_instance_state.instance_status */
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "main" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  map_public_ip_on_launch = true
  availability_zone       = local.azs["${count.index}"]
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "main" {
  count          = 3
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.main.id
}


resource "aws_route" "main" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}


resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ansible_host" {
  count           = 2
  ami             = "ami-0da72130d53f06a73"
  instance_type   = "t3a.micro"
  subnet_id       = aws_subnet.main["${count.index}" + 1].id
  key_name        = "matan_ansible"
  security_groups = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name  = "ansible-host_${count.index + 1}"
    Owner = "Matan Avital"
  }
}



resource "aws_instance" "ansible_master" {
  ami                    = "ami-0090396774e8e756a"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main[1].id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name               = "matan_ansible"
  /* user_data = base64encode(<<EOF
#!/bin/bash

sudo yum update -y
sudo yum install -y python3
curl -kL https://bootstrap.pypa.io/get-pip.py | python3
pip install ansible

EOF
  ) */
  tags = {
    Name  = "ansible_master"
    Owner = "Matan Avital"
  }
}

/* resource "null_resource" "transfer_file" {

  provisioner "remote-exec" {
    connection {
      host        = aws_instance.ansible_master.public_ip
      user        = "ec2-user"
      private_key = file("/home/develeap/.ssh/matan_ansible.pem")
    }

    inline = [
      "scp -i /home/develeap/.ssh/matan_ansible.pem /home/develeap/Documents/ansible_exercise/Ansible root@${aws_instance.ansible_master.public_ip}:~/"
    ]
  }
} */

/* -i /home/develeap/.ssh/matan_ansible.pem /home/develeap/Documents/ansible_exercise/Ansible */


/* 
  provisioner "file" {
    source      = "/home/develeap/Documents/ansible_exercise/Ansible/playbook.yml"
    destination = "~/playbook.yaml"
    

    connection {
      host        = aws_instance.ansible_master.public_ip
      user        = "ec2-user"
      private_key = file("/home/develeap/.ssh/matan_ansible.pem")
    }
  }
} */

/* resource "null_resource" "provision" {
 
  provisioner "remote-exec" {
    inline = ["chmod +w /etc/ansible"]

    connection {
      host        = aws_instance.ansible_master.public_ip
      user        = "ec2-user"
      private_key = file("/home/develeap/Downloads/ansible_key.pem")
    }
  }
} */




/* resource "local_file" "ansible_files" {
  connection {
    host        = aws_instance.ansible_master.public_ip
    user        = "ec2-user"
    private_key = file("/home/develeap/Downloads/ansible_key.pem")
  } */

/* provisioner "file" {
    source      = "/home/develeap/Documents/ansible_exercise/Ansible/hosts"
    destination = "/etc/ansible/hosts"
  } */

/* 
  provisioner "file" {
    source      = "/home/develeap/Documents/ansible_exercise/Ansible/index.html"
    destination = "/var/www/html/index.html"
  }
} */



output "instance_1_ip" {
  value = aws_instance.ansible_host[0].public_ip
}

output "instance_2_ip" {
  value = aws_instance.ansible_host[1].public_ip
}


resource "local_file" "ec2_ips" {
  content  = join("\n", [aws_instance.ansible_host[0].public_ip, aws_instance.ansible_host[1].public_ip])
  filename = "/home/develeap/Documents/ansible_exercise/Ansible/hosts"
}



resource "aws_iam_role" "ec2_ami_access" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Owner = "Matan Avital"
  }
}
resource "aws_iam_policy" "ami_access" {
  name   = "ami_access_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeImages",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ami_access_attachment" {
  name       = "ami_access_attachment"
  policy_arn = aws_iam_policy.ami_access.arn
  roles      = [aws_iam_role.ec2_ami_access.name]
}
