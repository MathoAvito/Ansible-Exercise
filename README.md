# Ansible and Terraform Exercise

This repository contains an exercise which leverages [Ansible](https://www.ansible.com/) and [Terraform](https://www.terraform.io/) to provision infrastructure on AWS and deploy a simple webpage on EC2 instances.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Instructions](#instructions)
3. [Project Structure](#project-structure)
4. [Files and Configuration Details](#files-and-configuration-details)
5. [Credits](#credits)
6. [Acknowledgements](#acknowledgements)
7. [See Also](#see-also)

## Getting Started <a name="getting-started"></a>

* Clone this repository to your local machine. 

    ```bash
    git clone https://github.com/MathoAvito/Ansible-Exercise.git
    ```

* Ensure you have Ansible, Terraform, and AWS CLI installed.

    ```bash
    sudo apt-get update && sudo apt-get install ansible terraform awscli -y
    ```

If not installed, you need to install them according to your OS specifications. Make sure you also have AWS CLI configured with your credentials.

## Instructions <a name="instructions"></a>

This exercise consists of the following steps:

1. Provision network and compute infrastructure on AWS using Terraform.

   Navigate to the Terraform directory and apply the changes:

   ```bash
   terraform init
   terraform apply
    ```
2. Set up an Ansible control node on one of the EC2 instances.

3. Configure the other EC2 instances as managed nodes (hosts).

4. Deploy a simple webpage on the managed nodes using Ansible.

   ```bash
   ansible-playbook playbook.yml
    ```
## Project Structure <a name="project-structure"></a>

The project has the following structure: 

```plaintext
/
├── Ansible/
│   ├── ansible.cfg
│   ├── playbook.yml
│   └── Webfile/
│       └── index.html
└── Terraform/
    ├── main.tf
    ├── variables.tf
    ├── modules/
    │   ├── compute/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   └── network/
    │       ├── main.tf
    │       ├── variables.tf
    │       └── outputs.tf
    └── entrypoint.sh
```
## Files and Configuration Details <a name="files-and-configuration-details"></a>

The files within this project are set up as follows:

### Terraform

The Terraform files within the `Terraform/` directory and its subdirectories are used to provision and configure AWS resources:

- `main.tf`: This is the main Terraform configuration file which references the `network` and `compute` modules.
- `variables.tf`: This file holds the declarations for variables used within the Terraform configuration files.
- `modules/network`: This module is used to provision network-related resources, such as a VPC, subnets, an internet gateway, and a security group.
- `modules/compute`: This module is used to provision compute-related resources, namely AWS EC2 instances.
- `entrypoint.sh`: This script installs the necessary dependencies for Ansible and sets up the Ansible control node.

### Ansible

The Ansible files within the `Ansible/` directory are used to configure the EC2 instances:

- `ansible.cfg`: This is the main Ansible configuration file which sets Ansible defaults and other configurations.
- `playbook.yml`: This Ansible playbook is used to deploy a simple webpage to the EC2 instances.


## See Also <a name="see-also"></a>

- [Ansible Documentation](https://docs.ansible.com/)
- [Terraform Documentation](https://www.terraform.io/docs/index.html)

## Credits <a name="credits"></a>

This project is maintained by [MathoAvito](https://github.com/MathoAvito).

## License <a name="license"></a>

This project is licensed under the MIT License. See the [LICENSE](https://github.com/MathoAvito/Ansible-Exercise/blob/main/LICENSE) file for details.