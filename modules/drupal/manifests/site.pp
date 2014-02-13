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

# Making docroot use facts 
# old: $docroot            = "/var/www/${title}",
# deprecate: 
# $drupalroot         = "${title}",

define drupal::site(

    $docroot            = undef,

    $makefile           = "${title}.make",
    $uri                = "${title}",
    $drushalias         = "${title}",
    
    $drushaliastemplate = 'drupal/alias-drushrc-php.erb',
    $drushaliasdir      = "/root/.drush",
    
    $mirror             = false,
  ) {

  include drupal
  
  if $docroot == undef {
    # Use global variable from Hiera.
    $docroot = hiera('drupal_docroot')
  }
  
  

  # Create site using make file.
  # Mirror sites have unique databaes pointing to the same codebase.
  if $mirror == false {
    exec { 
      "drush make ${uri}": 
        command => "drush make ${makefile} ${docroot}/${uri}",
        creates => "${docroot}",
    }
    
    # KV The key is in the form [form name].[parameter name] on D7
    exec {
      "drush site-install ${uri}":
        command => "drush site-install standard --db-url=mysql://${drupal_dbuser}:${drupal_dbpass}@${drupal_dbhost}:${drupal_dbport}/${drupal_dbname} --account-name=${drupal_admin_user} --account-pass=${drupal_admin_pass} --site-mail=${drupal_admin_mail} --account-mail=${drupal_admin_mail} --site-name=${drupal_site_name} install_configure_form.update_status_module='array(FALSE,FALSE)'",
    }
  }
  # @TODO else { # clone database and proceed with new vhost and drush alias }
  
  # Create new VHost entry.
  apache::vhost { "${uri}":
    port => 8080,
    docroot => "${docroot}/${uri}",
    priority => 25,
    servername => "${uri}",
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
  
  # Networking
  # A more robust example would be using a "managed" template, but it would eventually
  # require adding support for existing "non-managed" hosts.
  exec {
    "Modify /etc/hosts entries for ${uri}":
      
      # Do not add if there is already an entry.
      unless => 'grep -Fc '${uri}' /etc/hosts',    
      command => "sed -i '1s/^/127.0.0.1  ${uri}\n\n/' /etc/hosts",
  }  
  
  
  # @TODO
  # - Drupal install (db, user, etc) - optional.
  # - Networking/hosts entry - we can use a template and make hosts fully managed,
  #   or we can grep for an entry and if not found add it, if found update it.
  #   we should also make a backup of /etc/hosts before updating it.
  # - I'd be awesome if (optionally, default off), we could manage the host's host file using the same approach.
  
  

  /*
  
  case $operatingsystem {
    'centos', 'redhat', 'fedora': { $vdir   = '/etc/httpd/vhosts.d'
                                    $logdir = '/var/log/httpd'}
    'ubuntu', 'debian':           { $vdir   = '/etc/apache2/sites-enabled'
                                    $logdir = '/var/log/apache2'}
    default:                      { $vdir   = '/etc/httpd/conf.d'
                                    $logdir = '/var/log/apache2'}
  }
  

}