# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "vagrant-centos-x64-6.5"
  
  config.ssh.username="root"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network
  

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  
  #
  # Enable the network interface by default without using Network Manager.
  # http://wiki.centos.org/FAQ/CentOS6#head-b67e85d98f0e9f1b599358105c551632c6ff7c90
  #
  #sed -i -e 's@^ONBOOT="no@ONBOOT="yes@' ifcfg-eth0"    
  
  # Run yum update and setup network configuration before running
  # provider.
  

  #config.vm.provider :vmware_fusion do |v, override|

      #v.vmx["memsize"] = "1024"

      #v.vmx["ethernet0.present"] = "TRUE"
      #v.vmx["ethernet0.connectionType"] = "nat"
      #v.vmx["ethernet0.virtualDev"] = "e1000"
      #v.vmx["ethernet0.linkStatePropagation.enable"] = "TRUE"

      #v.vmx["ethernet0.addressType"] = "static"
      #v.vmx["ethernet0.generatedAddress"] = nil
      #v.vmx["ethernet0.startConnected"] = "TRUE"      
      
      #v.vmx["ethernet0.generatedAddress"] = nil
      #v.vmx["ethernet0.addressType"] = "static"
      #v.vmx["ethernet0.address"] = "00:0c:29:ac:f3:50"
      
     # v.vmx["displayName"] = "CentOS 6.5 LAMP"
      #v.vmx["annotation"] = ""
  #end  
  

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file centos_lamp.pp in the manifests_path directory.
  #
  # An example Puppet manifest to provision the message of the day:
  #
  # # group { "puppet":
  # #   ensure => "present",
  # # }
  # #
  # # File { owner => 0, group => 0, mode => 0644 }
  # #
  # # file { '/etc/motd':
  # #   content => "Welcome to your Vagrant-built virtual machine!
  # #               Managed by Puppet.\n"
  # # }

  # some.config.val = ENV['MYVAR'] || '123'
  
  # Install basic Puppet modules before provisioning Puppet.
  config.vm.provision :shell, :path => File.expand_path("../provision/install-puppet-modules.sh", __FILE__)
  
  config.vm.synced_folder "~/Sites", "/root/Sites"
  
  # Mount user hiera data on shared location.
  #config.vm.synced_folder "~/.hiera/.__hiera", "/etc/puppet/hieradata"
  
  hostname = ENV['HOSTNAME'];
  
  
  config.vm.provision :puppet do |puppet| 
    puppet.module_path = File.expand_path("../provision/modules", __FILE__)
    puppet.manifests_path = File.expand_path("../provision/manifests", __FILE__)
    puppet.manifest_file = "default.pp"
    puppet.options = "--verbose --debug"
    
    # Configure custom Facts.
    #"vagrant_hostname" => ENV['HOSTNAME'],
    #puppet.facter = { "proxy" => "proxy.host:80" }
    
    puppet.facter["alex_test"] = "yes"
    
   # puppet.facter = { 
    #  "vagrant_test" => "Facts WORK!!!", 
      #"vagrant_hostname" => ENV['HOSTNAME'], 
      #"vagrant_hostname2" => hostname 
   # }
   
   
    #puppet.hiera_config_path = File.expand_path("../provision/hiera.yaml", __FILE__)
    #puppet.working_directory = "~/.hiera"   
    
    # Hiera configuration.
    # hiera_config_path specifies the path to the Hiera configuration file stored on the host.
    # hiera_config_path can be relative or absolute. If it is relative, it is relative to the project root.
    #puppet.hiera_config_path = "hiera.yaml"
    
    # If the :datadir setting in the Hiera configuration file is a relative path,
    # working_directory should be used to specify the directory in the guest that path is relative to.
    #puppet.working_directory = "/tmp/vagrant-puppet"    
  end

end
