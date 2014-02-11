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
include drupal

# 1.0.1
# Testing autoloading (no include) - WORKS
apache::vhost {'testhost':
  port => 8080,
  docroot => '/var/www-testhost',
  priority => 25,
  servername => 'puppet',
}

# 1.0.2
# Use the generic drupal:: class for variables/elements that are likely to be shared across sites.
# That way we avoid repeating the same options many times.
# Examples: database host, database password, server admin (overridable), global settings.php options (such as caching and proxy).


# Create a new element for drush/drupal site that leverages apache::vhost inside.
# Test autoload #2 - 
drupal::site {'test.local':
  # drush alias params, make cwd
  #docroot => '/var/www-testhost',
 # uri => 'default.local',
  # make params
  # makefile: we have a shared make file directory in ~ where we go and grab the make files from
  # alternatively, it would be much easier if we just accepted an URL?
  # but URLs won't work for makefiles in private repos. For that reason, for now it's easier
  # just to create a shared dir, and let the user clone/download the make file there.
  makefile => 'test.make',
  #drupalroot => 'lolololo',
}





# 1.0.3
# Have either Cocoa or Drupal manage the VHost YAML site.

# VHost Hidra/YAML definition
# apache::vhost::user_hosts
#   -servername: "puppet"
#     -port: 8080
#     -docroot: "~/Sites/lsd_test/htdocs"
#     -priority: 25

# 1.0.4
# Grab most options from drush qd and drush make from Hidra/YAML files.
