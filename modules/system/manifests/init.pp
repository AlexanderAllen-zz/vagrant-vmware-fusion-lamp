class system {
	$libraries = [
		'curl', 'openssl', 'ncurses-devel', 'pcre-devel',
		'ImageMagick', 'ImageMagick-devel', 'man'
    # vim
	]
  
	package { $libraries:
		ensure => present
	}
  
  
  # Use Puppet to configure Puppet!
  # Hiera is part of Puppet as of 3.x
  # https://github.com/puppetlabs/hiera
  
  # Hiera main config file.
	file { '/etc/hiera.yaml':
		source => 'puppet:///modules/system/hiera.yaml',
		owner => 'root',
		group => 'root',
    ensure => 'file'
  }
  
  # Hiera hierarchy files.
	file { '/var/lib/hiera/CentOS.yaml':
		source => 'puppet:///modules/system/CentOS.yaml',
		owner => 'root',
		group => 'root',
    ensure => 'file'
  }
	file { '/var/lib/hiera/common.yaml':
		source => 'puppet:///modules/system/common.yaml',
		owner => 'root',
		group => 'root',
    ensure => 'file'
  }  
  
  
  
  
  
  /*
  
  $puppet_module_dir = [ 
    '/vagrant/puppet', '/vagrant/puppet/modules',
  ]  
  
	file { $puppet_module_dir:
		path => '/vagrant/puppet',
		ensure => 'directory',
    owner => 'root',
    group => 'root',
    mode => 750
	}*/

	
	
	
}