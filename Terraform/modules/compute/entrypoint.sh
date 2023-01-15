#!/bin/bash

sudo yum update -y
sudo yum install -y python3
curl -kL https://bootstrap.pypa.io/get-pip.py | python3
pip install ansible