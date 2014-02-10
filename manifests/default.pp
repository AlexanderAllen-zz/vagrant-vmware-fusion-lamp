# default path
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

# Ensure our custom semaphore directory exists.
# Controls which commands are run only once (on the first provision).
file { '/tmp/vagrant-puppet-semaphore':
	ensure => 'directory',
	owner => 'root',
	group => 'root'
}		

include apache
include php
include php::pear
include mysql
include varnish