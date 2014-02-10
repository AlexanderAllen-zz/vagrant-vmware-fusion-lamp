class mysql {
	# Missing Varnish, Memcached, APC, Zend Debugger, XDebug, New Relic
	# XDebug and Zend Debugger should be separate for ease of configuration.
	
	# Install PHP and all the development libraries.
	$libraries = [
		'mysql'
		
	    #'mysql-community-common', 'mysql-community-libs',
		#'mysql-community-client', 
	]
	
	package { $libraries:
		ensure => present
	}
}