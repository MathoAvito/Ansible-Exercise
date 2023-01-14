resource "aws_instance" "ansible_host" {
  count           = var.ansible_hosts
  ami             = "ami-0da72130d53f06a73"
  instance_type   = "t3a.micro"
  subnet_id       = var.subnets["${count.index}" + 1].id
  key_name        = "matan_ansible"
  security_groups = [var.security_groups.id]

  tags = {
    Name  = "ansible-host_${count.index + 1}"
    Owner = "Matan Avital"
  }
}



resource "aws_instance" "ansible_master" {
  ami                    = "ami-0090396774e8e756a"
  instance_type          = "t3a.micro"
  subnet_id              = var.subnets[1].id
  vpc_security_group_ids = [var.security_groups.id]
  key_name               = "matan_ansible"

  tags = {
    Name  = "ansible_master"
    Owner = "Matan Avital"
  }

  connection {
    host = aws_instance.ansible_master.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/matan_ansible.pem")
  }

   provisioner "remote-exec" {
    inline = [
       "sudo mkdir ~/ansible",
       "sudo chmod 777 ~/ansible",
       "sudo chmod 600 /home/ec2-user/.ssh/matan_ansible.pem",
       "export ANSIBLE_CONFIG=/home/ec2-user/ansible/ansible.cfg"
    ]
  }

  provisioner "file" {
    source      = "/home/develeap/.ssh/matan_ansible.pem"
    destination = "/home/ec2-user/.ssh/matan_ansible.pem"
  }

  provisioner "file" {
    source      = "/home/develeap/Documents/ansible_exercise/Ansible/ansible.cfg"
    destination = "/home/ec2-user/ansible/ansible.cfg"
  }

  provisioner "file" {
    source      = "/home/develeap/Documents/ansible_exercise/Ansible/hosts"
    destination = "/home/ec2-user/ansible/hosts"
  }

  provisioner "file" {
    source      = "/home/develeap/Documents/ansible_exercise/Ansible/playbook.yml"
    destination = "/home/ec2-user/ansible/playbook.yml"
  }
}

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