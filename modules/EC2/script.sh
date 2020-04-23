#!/bin/bash
sudo add-apt-repository universe
sudo apt-get install gdebi-core -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
apt-get install ruby -y
sudo apt-get update -y
sudo apt-get install awscli -y
cd /home/ubuntu
aws s3 cp s3://aws-codedeploy-us-east-2/latest/install . --region us-east-2
chmod +x ./install
./install auto
sudo service codedeploy-agent status
sudo service codedeploy-agent start