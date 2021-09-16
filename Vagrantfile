
VAGRANTFILE_API_VERSION = "2"
VAGRANT_EXPERIMENTAL="disks"

# Total managed servers Max 9 servers -- See IP_NETWORK
MANAGED_SERVERS_NUMBER=1 
MANAGED_SERVERS_WITH_EXTRA_DISK=[1,2]
CONTROL_SERVER_NAME="control"
MANAGED_SERVERS_NAME="server"
SERVERS_DOMAIN="example.com"
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
	
	# USER_ANSIBLE - true/false to create ansible user 
	# INSTALL_PYTHON - true/false to install python
    config.vm.provision "shell", path: "startup.sh", env: {"USER_ANSIBLE" => 0, "INSTALL_PYTHON" => 0}
 
    # Configure MANAGED_SERVERS_NUMBER of servers
	(0..MANAGED_SERVERS_NUMBER).each do |i|
		if i == 0
			server_name = CONTROL_SERVER_NAME
		else
			server_name = "#{MANAGED_SERVERS_NAME}#{i}"
		end
		config.vm.define "#{server_name}" do |node|
			if i == 0 
				node.vm.provision "shell", path: "startup.sh", env: {"USER_ANSIBLE" => 1, "INSTALL_PYTHON" => 1}
				node.vm.provision "shell", inline: <<-INPUT
				for ((i=1; i<=#{MANAGED_SERVERS_NUMBER}; i++))
				do
				  sudo echo "#{IP_NETWORK}#{i} #{MANAGED_SERVERS_NAME}#{i} #{MANAGED_SERVERS_NAME}#{i}.#{SERVERS_DOMAIN}" >> /etc/hosts
				done
			  INPUT
			end
			node.vm.box = "generic/rhel8"
			node.vm.hostname = "#{server_name}.#{SERVERS_DOMAIN}"
			node.vm.network "private_network", name: "vboxnet0", ip: "192.168.56.12#{i}"
			
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
				if ( MANAGED_SERVERS_WITH_EXTRA_DISK.include?(i) )
					#Provision extra disk
					file_to_disk = "#{server_name}.vdi"
					unless File.exists?(file_to_disk)
						vbox.customize ['createhd', '--filename', file_to_disk, '--size', 5 * 1024]
					end
					vbox.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
				end
			end

		end
	end
end