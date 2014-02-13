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
  
  notice("TEST NOTICE drupal_admin_user ${drupal_admin_user}")
  
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
  

}