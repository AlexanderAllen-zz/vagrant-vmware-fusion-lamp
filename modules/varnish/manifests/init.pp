class varnish {
	
	# Install the latest version of Varnish.
	exec { 'download varnish RPM': 
		command => 'wget http://repo.varnish-cache.org/redhat/varnish-3.0/el6/noarch/varnish-release/varnish-release-3.0-1.el6.noarch.rpm',
		creates => '/usr/sbin/varnishd'
	}
	
	exec { 'execute varnish RPM': 
		command => 'rpm --nosignature -i varnish-release-3.0-1.el6.noarch.rpm', 
		require => Exec['download varnish RPM'],
		creates => '/usr/sbin/varnishd'
	}
	
	package { "varnish":
		ensure => present
	}
	
	exec { 'Set varnish chkconfig': 
		command => 'chkconfig varnish on',
		creates => '/usr/sbin/varnishd',
		require => Package["varnish"]
	}
	
	# Set Varnish to listen on port 8080.
	exec { 'Update /etc/sysconfig/varnish': 
		command => "sed -i 's/VARNISH_LISTEN_PORT=6081/VARNISH_LISTEN_PORT=80/g' /etc/sysconfig/varnish",
		require => Package["varnish"]
	}
	
	# sed -ir 's/port\s=\s"80"/port="8080"/g' /etc/varnish/default.vcl
	exec { 'Update /etc/varnish/default.vcl': 
		command => "sed -ir 's/port\s=\s\"80\"/port=\"8080\"/g' /etc/varnish/default.vcl",
		require => Package["varnish"]
	}
	
	/*
	exec { 'Set varnish semaphore': 
		command => 'touch /tmp/vagrant-puppet-semaphore/varnish', 
		require => Package["varnish"],
		creates => '/tmp/vagrant-puppet-semaphore/varnish'
	}*/
	
	# Ensure Varnish is running.
	service {
		"varnish":
		ensure => running,
		require => Package["varnish"]
	}
}
