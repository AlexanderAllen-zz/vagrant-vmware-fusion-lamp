class memcached {
	
	# This will install an older version of memcached (1.4.4 as of Feb 02, 2014),
	# but with an out-of-the box init.d deamon included.
	$libraries = [
		'memcached', 'libevent-devel', 'php-pecl-memcache'
	]
  
	package { $libraries:
		ensure => present
	}
	
	# Ensure memcached is running, we're using default settings for development.
	service {
		"memcached":
		ensure => running,
		require => Package["memcached"]
	}
	
}