/*
 * Puppet Drush class.
 *
 * Installs Drush via PEAR.
 * See https://github.com/drush-ops/drush for more information.
 * Default "lib" directory is /usr/share/pear/drush/drush.php.
 *
 */
class php::drush {
	include php
	
	exec {"discover pear.drush.org":
		command => "/usr/bin/pear channel-discover pear.drush.org",
		require => Exec['pear update-channels'],
		creates => '/root/.drush'
	}
	
	exec { 'pear install drush': 
		command => '/usr/bin/pear install drush/drush',
		require => Exec['discover pear.drush.org'],
		creates => '/root/.drush'
	}
	
	# Make a copy of drush .bashrc in user's .drush directory.
	file { '.drush_bashrc':
		path => '/root/.drush_bashrc',
		ensure => file,
		source => '/usr/share/pear/drush/examples/example.bashrc',
		require => Exec['pear install drush']
	}
	
	# Source in example.bashrc only if source file exists,
	# and we have not sourced it in already.
	exec { 'source example.bashrc': 
		command => "printf '\n\n# Added by AlexanderAllen/vagrant-vmware-fusion-lamp.\nsource /root/.drush_bashrc' >> /root/.bashrc",
		#onlyif => 'ls -l /root/.drush_bashrc | wc -l',
		unless => "grep -Fc '.drush_bashrc' /root/.bashrc",
		require => File['.drush_bashrc'],
	}
	
	# @TODO PS1 prompt
}
