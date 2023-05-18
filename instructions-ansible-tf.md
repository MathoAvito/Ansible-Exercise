# Ansible Terraform Exercise

## 1. Terraform - Provision Network and Compute Infrastructure

   Provision the following:
   - VPC
   - Subnets
   - 3 EC2 instances
   - Security group with:
     - Inbound HTTP from anywhere
     - Inbound SSH from your IP
     - Anything inbound if its source is **from within** the VPC

## 2. Setup Servers

   Configure the EC2 instances as follows:
   - One EC2 instance will act as the Ansible _Control Node_. Install Ansible on it (using `user_data`)
   - The other two instances will act as the _Managed Nodes_ (Hosts). You'll need to expose them with a public IP and ensure the Control node has the required access to them

## 3. Ansible - Write Your Own

   Create the following Ansible components:
   - Static _inventory file_ with the IP addresses of the two Managed Nodes
   - Ansible configuration file (ansible.cfg)<br>
     <sub>If you are using a different repo than '/etc/ansible/ansible.cfg', override the ansible config by executing `export ANSIBLE_CONFIG=path/to/new/config`</sub>
   - Playbook that deploys [this webpage](https://raw.githubusercontent.com/MathoAvito/Ansible-Exercise/main/Ansible/Webfile/index.html)<br>
     <sub>Note: you'll need to **install** and **start** an HTTP server!</sub>

## 4. Check

   Finally, validate your setup:
   - Connect to the Ansible Control Node
   - Run the Playbook
   - Open the public IP addresses of the instances and check if you can see the website
