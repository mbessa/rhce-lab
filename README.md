# Vagrant provision for RHCE labs

## This repository helps provision a lab for RHCSA or RHCE using VirtualBox

### **Requirements**

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/)

### **Usage**

```bash
# Clone repo:
❯ git clone git@github.com:mbessa/rhce-lab.git

# To start VM's:
❯ cd rhce-lab
❯ vagrant up
....

# Check status:
❯ vagrant status
Current machine states:

control                   running (virtualbox)
server1                   running (virtualbox)
server2                   running (virtualbox)
server3                   running (virtualbox)
server4                   running (virtualbox)

# login

❯ vagrant ssh control

OR

❯ ssh ansible@192.168.56.120

OR 

❯ ssh root@192.168.56.120

```



### **VM's launched by default**


### Users passwords:
> root: password
>
> vagrant: vagrant
>
> ansible: password 



|       hostname      	|       IP       	| python3 	| User ansible 	| Extra disk 	|
|:-------------------:	|:--------------:	|:-------:	|:------------:	|:----------:	|
| control.example.com 	| 192.168.56.120 	|   yes   	|      yes   	|     DVD    	|
| server1.example.com 	| 192.168.56.121 	|    no   	|       no     	|     5G     	|
| server2.example.com 	| 192.168.56.122 	|    no   	|       no     	|     5G     	|
| server3.example.com 	| 192.168.56.123 	|    no   	|       no     	|     no     	|
| server4.example.com 	| 192.168.56.124 	|    no   	|       no     	|     no     	|


Control node configuration:
```properties
/etc/hosts populated with managed hosts IP HOSTNAME and FQDN
example: 
...
 
192.168.56.121 server1 server1.example.com
192.168.56.122 server2 server2.example.com

...


```

## **Variables**

### There's a couple variables you can tweak to adjust your lab to your needs


`MANAGED_NUMBER` - Managed Server quantity ( default 4, current max = 9 ) 

`MANAGED_WITH_EXTRA_DISK` -  Extra disk added to managed servers | Array (default [1,2])

`EXTRA_DISK_SIZE_GB` - Extra disk size in GB ( default 5 )

`MANAGED_USER_ANSIBLE` - Create user ansible in managed hosts, absent by default ( default 0 )

`MANAGED_INSTALL_PYTHON` - Install python 3 in managed nodes, false by default (default 0)

`CONTROL_USER_ANSIBLE` - Create user ansible in control host, present by default ( default 1 )

`CONTROL_INSTALL_PYTHON` - Install python 3 in control host, install by default (default 1)


`CONTROL_HOSTNAME` - Hostname for control host (default "control")

`MANAGED_HOSTNAME_PREFIX` - Hostname prefix for managed hosts. Server number dynamically added (default "server")

`DOMAIN` -  Domain for fqdn (default "example.com")

`IP_NETWORK` - Network prefix, managed node server number added (default "192.168.56.12")


