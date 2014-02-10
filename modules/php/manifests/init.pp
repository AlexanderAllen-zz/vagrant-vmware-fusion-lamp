class php {
	# Missing Varnish, Memcached, APC, Zend Debugger, XDebug, New Relic
	# XDebug and Zend Debugger should be separate for ease of configuration.
	
	# Install PHP and all the development libraries.
	$libraries = [
		'php', 'php-common', 'php-devel', 'php-cli', 'php-fpm', 'php-gd', 'php-ldap',
		'php-pear', 'php-pecl-apc', 'php-pecl-memcache',			
		'php-mysql', 'php-soap', 'php-xml', 'php-xmlrpc', 
		'php-pecl-apc-devel', 'php-bcmath', 'php-mcrypt',
		'php-imap', 'php-odbc', 'php-zts'
	]
	# removed pecl from libraries, as it is included as part of php common
	
	package { $libraries:
		ensure => present
	}
}