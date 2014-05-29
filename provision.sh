#!/usr/bin/env bash

INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`

sudo apt-get update -y

sudo apt-get install -y unzip

#
# AspectJ doesn't like java 7
# http://stackoverflow.com/questions/15678417/error-when-using-aspectj-aop-with-java-7
#
sudo apt-get install -y openjdk-6-jdk

# tomcat upstart https://gist.github.com/witscher/2924017
sudo mv /vagrant/tomcat.conf /etc/init

# redirect port 80 to 8080
sudo mv /vagrant/preup /etc/network/if-pre-up.d/
sudo mv /vagrant/postdown /etc/network/if-post-down.d/
sudo chmod 774 /etc/network/if-pre-up.d/preup
sudo chmod 774 /etc/network/if-post-down.d/postdown

# http://stackoverflow.com/questions/7739645/install-mysql-on-ubuntu-without-password-prompt
# gets rid of the mysql password prompts
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
sudo apt-get install -y mysql-server

# http://stackoverflow.com/questions/3907666/mysql-wont-start-ibdata1-corrupt-operating-system-error-number-13-permis
# to move the mysql data dir do the following.
# MUST edit the apparmor file or it will error!!!!!!!
# sudo service mysql stop
# sudo rm -rf /var/lib/mysql
# sudo ln -s /data/mysql /var/lib/mysql
# sudo vi  /etc/apparmor.d/usr.sbin.mysqld

#
# Install AWS command line tools
#
wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
rm -rf awscli-bundle*

#
# Copy credentials
#
cp -rf /vagrant/creds/.ssh ~/
mv /vagrant/creds/.dockercfg ~/
mv /vagrant/creds/.gitconfig ~/
mv /vagrant/creds/.git-credentials ~/
mv /vagrant/creds/.git-credential-cache ~/
mkdir -p ~/.sbt/0.13/
mv /vagrant/creds/sonatype.sbt ~/.sbt/0.13/
mkdir -p ~/.aws
mv /vagrant/creds/config ~/.aws/

#
# Mount old data
#
aws ec2 attach-volume --volume-id vol-c00af683 --instance-id $INSTANCE_ID --device /dev/xvdo
sudo mkdir /old
sudo mount /dev/xvdo /old
sudo chown ubuntu:ubuntu /old
echo '/dev/xvdo /old ext4 defaults 0 2' | sudo tee -a /etc/fstab

# TODO check permissions on /data
#
# Mount data drive
#
aws ec2 attach-volume --volume-id vol-8657abc3 --instance-id $INSTANCE_ID --device /dev/xvdd
sudo mkdir /data
sudo mount /dev/xvdd /data
sudo chown ubuntu:ubuntu /data
echo '/dev/xvdd /data ext4 defaults 0 2' | sudo tee -a /etc/fstab
