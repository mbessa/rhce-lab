
VAGRANTFILE_API_VERSION = "2"
VAGRANT_EXPERIMENTAL="disks"

# Total managed servers Max 9 servers -- See IP_NETWORK
MANAGED_NUMBER=4 
MANAGED_WITH_EXTRA_DISK=[1,2]
EXTRA_DISK_SIZE_GB=5
MANAGED_USER_ANSIBLE=0
MANAGED_INSTALL_PYTHON=0
CONTROL_USER_ANSIBLE=1
CONTROL_INSTALL_PYTHON=1

# Naming
CONTROL_HOSTNAME="control"
MANAGED_HOSTNAME_PREFIX="server"
DOMAIN="example.com"

# Network
IP_NETWORK="192.168.56.12" 

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	# Disable vagrant-vbguest auto update
	if defined? VagrantVbguest
		config.vbguest.auto_update = false
	end

	# Setting language locale environment variable
	ENV["LC_ALL"] = "en_US.UTF-8"
	ENV["LANG"] = "en_US.UTF-8"

	# Disable vagrant ssh key insertion
    config.ssh.insert_key = false
	
	# Script ENV variables
	# USER_ANSIBLE - true/false to create ansible user 
	# INSTALL_PYTHON - true/false to install python
    config.vm.provision "shell", path: "startup.sh", env: {"USER_ANSIBLE" => MANAGED_USER_ANSIBLE, "INSTALL_PYTHON" => MANAGED_INSTALL_PYTHON}
 
    # Configure MANAGED_NUMBER of servers
	(0..MANAGED_NUMBER).each do |i|
		if i == 0
			server_name = CONTROL_HOSTNAME
		else
			server_name = "#{MANAGED_HOSTNAME_PREFIX}#{i}"
		end
		config.vm.define "#{server_name}" do |node|
			if i == 0 
				node.vm.provision "shell", path: "startup.sh", env: {"USER_ANSIBLE" => CONTROL_USER_ANSIBLE, "INSTALL_PYTHON" => CONTROL_INSTALL_PYTHON}
				node.vm.provision "shell", inline: <<-INPUT
				for ((i=1; i<=#{MANAGED_NUMBER}; i++))
				do
				  sudo echo "#{IP_NETWORK}${i} #{MANAGED_HOSTNAME_PREFIX}${i} #{MANAGED_HOSTNAME_PREFIX}${i}.#{DOMAIN}" >> /etc/hosts
				done
			  INPUT
			end
			node.vm.box = "generic/rhel8"
			node.vm.hostname = "#{server_name}.#{DOMAIN}"
			node.vm.network "private_network", name: "vboxnet0", ip: "#{IP_NETWORK}#{i}"
			
			node.vm.provider "virtualbox" do |vbox|
				vbox.customize [
					"modifyvm", :id,
					"--memory", 512,
					"--cpus", 1,
					"--name", server_name
				]
				# Add dvd to control node
				if ( i == 0 )
					vbox.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'dvddrive', '--medium', 'emptydrive']
				end
				# Extra disk provision
				if ( MANAGED_WITH_EXTRA_DISK.include?(i) )
					file_to_disk = "#{server_name}.vdi"
					unless File.exists?(file_to_disk)
						vbox.customize ['createhd', '--filename', file_to_disk, '--size', EXTRA_DISK_SIZE_GB * 1024]
					end
					vbox.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
				end
			end

		end
	end
end