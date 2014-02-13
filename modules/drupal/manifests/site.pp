# = Class: drupal
#
# This class installs/configures/manages Drupal.
# We manage Drupal on a separate class because you can have multiple vhosts
# looking at the same database, but not the other way around.
# This allows for easier testing of feature updates and rollbacks (reverts),
# without having to worry about about keeping content in sync.
#
# == Parameters:
#
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class {'default.local':
#     servers => [ "ntp1.example.com dynamic",
#                  "ntp2.example.com dynamic", ],
#   }
#   class {'default.local':
#     enable => false,
#     ensure => stopped,
#   }
#   # Create a new site using a make file.
#   class {'default.local':
#     install => make | quick | false
#     makefile => 'test.make',
#     drupalroot => 'target-directory',
#     alias => [ "def", "def.local",
#                "def.dev", "def.qa", "def.prof", ],
#     publicdir => 'sites/default/files',
#     privatedir => 'sites/default/private',
#     tempdir => '/tmp',
#     profile => 'minimal',
#     databasename => 'defaultdb', --db-url
#     databaseuser => 'root,  => --db-su
##     databasepwd => 'root',=> --db-pw
#
#     site-name,
#     site-mail,
#     root, # path to drupal rot
#     # --no-server by default
#    
#   }
#
# Class used to manage Drupal sites?
#


# define drupal::alias
# integrate some config options into master module?

# Drush takes care of actually creating the Drupal site (at least the schema)
# Puppet takes care of creating the vhost container, alias, and any other manual task.



define drupal::site(
    $makefile           = "${title}.make",
    $uri                = "$title",
    $drushalias         = "$title",
    $drupalroot         = "$title",
    $drushaliastemplate = 'drupal/alias-drushrc-php.erb',
    $drushaliasdir      = "/root/.drush",
    $docroot            = "/var/www/${title}",
  ) {

  include drupal

  # Create site using make file.
  # All makefile parameters are relative to the shared Sites directory.
  exec { 
    "drush make": 
      command => "drush make ${makefile} ${docroot}",
      creates => "$docroot",
  }
  
  # Create new VHost entry.
  apache::vhost { "${uri}":
    port => 8080,
    docroot => "${docroot}",
    priority => 25,
    servername => $uri,
  }    
  
  # Create drush alias for site.
  file {
    "${drushaliasdir}/${drushalias}.aliases.drushrc.php":
      content => template($drushaliastemplate),
      owner   => 'root',
      group   => 'root',
      mode    => '755',
  }
  
  # Clear drush cache, in case we are re-provisioning.
  exec {
    "clear drush cache":
      command => 'drush cc drush',
  }
  
  # @TODO
  # - Drupal install (db, user, etc) - optional.
  # - Networking/hosts entry - we can use a template and make hosts fully managed,
  #   or we can grep for an entry and if not found add it, if found update it.
  #   we should also make a backup of /etc/hosts before updating it.
  # - I'd be awesome if (optionally, default off), we could manage the host's host file using the same approach.
  
  
  # file for drush alias, accept shortcuts

  /*
  
  case $operatingsystem {
    'centos', 'redhat', 'fedora': { $vdir   = '/etc/httpd/vhosts.d'
                                    $logdir = '/var/log/httpd'}
    'ubuntu', 'debian':           { $vdir   = '/etc/apache2/sites-enabled'
                                    $logdir = '/var/log/apache2'}
    default:                      { $vdir   = '/etc/httpd/conf.d'
                                    $logdir = '/var/log/apache2'}
  }
  
  file {
    "${vdir}/${priority}-${name}.conf":
      content => template($template),
      owner   => 'root',
      group   => 'root',
      mode    => '755',
      require => Package['httpd'],
      notify  => Service['httpd'],
  }
  */

}