#create amazonlinux ec2 with t2.micro and 30 gb of ebs with port 8081 

sudo yum update -y
sudo yum install wget -y
sudo yum install java-1.8.0-openjdk.x86_64 -y
sudo mkdir /opt && cd /opt
sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/nexus-3.0.2-02-unix.tar.gz
sudo tar -xvf nexus-3.0.2-02-unix.tar.gz
sudo mv nexus-3.0.2-02 nexus
sudo adduser nexus
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
sudo echo "run_as_user="nexus"" > /opt/nexus/bin/nexus.rc
sudo tee /etc/systemd/system/nexus.service > /dev/null << EOL
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOL
sudo chkconfig nexus on
sudo systemctl start nexus
sudo systemctl status nexus

