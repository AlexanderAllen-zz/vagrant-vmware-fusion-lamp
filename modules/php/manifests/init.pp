class php {
	# Missing Varnish, APC, Zend Debugger, XDebug, New Relic
	# XDebug and Zend Debugger should be separate for ease of configuration.
	
	# Install PHP and all the development libraries.
	$libraries = [
		'php', 'php-common', 'php-devel', 'php-cli', 'php-fpm', 'php-gd', 'php-ldap',
		'php-pear', 'php-pecl-apc',
		'php-mysql', 'php-soap', 'php-xml', 'php-xmlrpc', 
		'php-pecl-apc-devel', 'php-bcmath', 'php-mcrypt',
		'php-imap', 'php-odbc', 'php-zts',
    
    # Drupal 7 requires mbstring for Unicode support.
    # Drupal installation will not complete without this.
    'php-mbstring',
	]
	
	package { $libraries:
		ensure => present
	}
}