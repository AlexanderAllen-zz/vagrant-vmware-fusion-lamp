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
include php::drush
include mysql
include memcached
include varnish

# 1.0.1
# Testing autoloading (no include)
apache::vhost {'testhost':
  port => 8080,
  docroot => '/var/www-testhost',
  priority => 25,
  servername => 'puppet',
}

# 1.0.2
# Create a new element for drush/drupal site that leverages apache::vhost inside.
