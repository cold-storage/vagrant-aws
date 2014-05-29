# https://github.com/mitchellh/vagrant-aws

Vagrant.configure("2") do |config|

  # vagrant up --provider=aws
  config.vm.box = "aws"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = File.read("#{ENV['HOME']}/.aws_key")
    aws.secret_access_key = File.read("#{ENV['HOME']}/.aws_secret_key")
    aws.keypair_name = "aws"
    # Ubuntu Server 14.04 LTS (PV) - ami-018c9568 (64-bit)
    aws.ami = "ami-018c9568"
    aws.instance_type = 't1.micro'
    # aws.security_groups = ['sg-fc42c595']
    aws.region = 'us-east-1'
    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "~/.ssh/aws.pem"
  end

  config.vm.provision "shell" do |s|
    s.privileged = false # don't run as root
    # s.keep_color = true
    s.path = "provision.sh"
  end

end
