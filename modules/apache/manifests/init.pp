class apache {
	
	package { "httpd":
		ensure => present
	}
	
	# Install PHP and all the development libraries.
#	$libraries = [
#		'php', 'php-common', 'php-devel', 'php-cli', 'php-fpm',
#		'php-curl', 'php-gd','php-imagick', 'php-ldap',
#		'php-pear', 'php-pecl-apc', 'php-pecl-memcache',			
#		'php-mysql', 'php-soap', 'php-xml', 'php-xmlrpc', 
#		'php-pecl-apc-devel', 'php-bcmath', 'php-mcrypt',
#		'php-imap', 'php-odbc', 'php-zts',
#		'openssl', 'mysql-community-common', 'mysql-community-libs',
#		'mysql-community-client', 'ncurses-devel', 'pcre-devel'	
#	]
	
#	$libraries = [
#		'php', 'php-common', 'php-devel', 'php-cli', 'php-pear'
#	]
	
#	package { $libraries: 
#		ensure => "installed" 
#	}
	
	# Install Postfix
	#$mail = [
	#	'postfix', 'mailutils'
	#]
	#package { $mail: ensure => "installed" }	
	#exec { 'autostartmail': 
#		command => '/usr/sbin/update-rc.d postfix defaults', 
#		require => Package['postfix']
#	}
	
	

	# If no version number is supplied, the latest stable release will be
	# installed. In this case, upgrade PEAR to 1.9.2+ so it can use
	# pear.drush.org without complaint.
	#pear::package { "PEAR": }
	#pear::package { "Console_Table": }

	# Version numbers are supported.
	#pear::package { "drush":
	  #version => "4.5.0",
	##  repository => "pear.drush.org",
	#}
	


	
	# create a symlink which points a src folder to our projects src folder
	# we should create symlink instead from ~/.drush to ~/.drush
	#file {'/var/www/src':
	#	ensure => 'link',
	#	target => '/vagrant/src',
	#	require => Package['apache2']
	#}
	
	file { '/etc/httpd/conf.d/custom.conf':
		source => 'puppet:///modules/apache/custom.conf',
		owner => 'root',
		group => 'root',
		require => Package['httpd']
	}
	
	# Ensure vhosts.d exists.
	file { '/etc/httpd/vhosts.d':
		ensure => 'directory',
		owner => 'root',
		group => 'root',
		require => Package['httpd']
	}		
	
	file { '/etc/httpd/vhosts.d/default.conf':
		source => 'puppet:///modules/apache/default.conf',
		owner => 'root',
		group => 'root',
		require => Package['httpd']
	}
	
	# Ensure httpd is running.
	service {
		"httpd":
		ensure => running,
		require => Package["httpd"];
	}
	
	
}
