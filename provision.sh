#!/usr/bin/env bash

INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`

sudo apt-get update -y

sudo apt-get install -y unzip

wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
rm -rf awscli-bundle*

cp -rf /vagrant/creds/.ssh ~/
cp -rf /vagrant/creds/.dockercfg ~/
cp -rf /vagrant/creds/.gitconfig ~/
cp -rf /vagrant/creds/.git-credentials ~/
cp -rf /vagrant/creds/.git-credential-cache ~/
mkdir -p ~/.sbt/0.13/
cp -rf /vagrant/creds/sonatype.sbt ~/.sbt/0.13/
mkdir -p ~/.aws
cp -rf /vagrant/creds/config ~/.aws/

aws ec2 attach-volume --volume-id vol-c00af683 --instance-id $INSTANCE_ID --device /dev/xvdo
sudo mkdir /old
sudo mount /dev/xvdo /old
sudo chown ubuntu:ubuntu /old
echo '/dev/xvdo /old ext4 defaults 0 2' | sudo tee -a /etc/fstab

aws ec2 attach-volume --volume-id vol-8657abc3 --instance-id $INSTANCE_ID --device /dev/xvdd
sudo mkdir /data
sudo mount /dev/xvdd /data
sudo chown ubuntu:ubuntu /data
echo '/dev/xvdd /data ext4 defaults 0 2' | sudo tee -a /etc/fstab
