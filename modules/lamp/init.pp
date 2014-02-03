class lamp {
	
	package { "httpd":
		ensure => present
	}
	
	# Install PHP and all the development libraries.
	$libraries = [
		'php', 'php-common', 'php-devel', 'php-cli', 'php-fpm',
		'php-curl', 'php-gd','php-imagick', 'php-ldap',
		'php-pear', 'php-pecl-apc', 'php-pecl-memcache',			
		'php-mysql', 'php-soap', 'php-xml', 'php-xmlrpc', 
		'php-pecl-apc-devel', 'php-bcmath' 'php-mcrypt',
		'php-imap', 'php-mysql', 'php-odbc', 'php-zts',
		'openssl', 'mysql-community-common', 'mysql-community-libs',
		'mysql-community-client', 'ncurses-devel', 'pcre-devel'	
	]
	
	package { $libraries: 
		ensure => "installed" 
	}
	
	# Install Postfix
	$mail = [
		'postfix', 'mailutils'
	]
	package { $mail: ensure => "installed" }	
	exec { 'autostartmail': 
		command => '/usr/sbin/update-rc.d postfix defaults', 
		require => Package['postfix']
	}


	
	# create a symlink which points a src folder to our projects src folder
	# we should create symlink instead from ~/.drush to ~/.drush
	#file {'/var/www/src':
	#	ensure => 'link',
	#	target => '/vagrant/src',
	#	require => Package['apache2']
	#}
	
	file { '/etc/httpd/conf.d/custom.conf':
		source => 'puppet:///modules/lamp/custom.conf',
		owner => 'root',
		group => 'root',
		require => Package['httpd']
	}
	
	# Ensure vhosts.d exists.
	file { '/etc/httpd/conf.d/vhosts.d':
		ensure => 'directory',
		owner => 'root',
		group => 'root',
	}		
	
	file { '/etc/httpd/conf.d/vhosts.d/default.conf':
		source => 'puppet:///modules/lamp/default.conf',
		owner => 'root',
		group => 'root',
	}	

	# Install PHP Packages and restatart apache afterwards.
	# TODO Check what packages we currently have installed.

	#service { "httpd": 
#		require => Package["httpd"], 
#		subscribe => [
#			File['/etc/httpd/sites-available/default']
			#Package[
			#]
#		]
#	}
	
	
}
