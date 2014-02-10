class php::pear {
  include php

  # upgrade PEAR
  exec {"pear upgrade":
  	command => "/usr/bin/pear upgrade",
    require => Package["php-pear"],
	returns => [ 0, '', ' ']
  }

  # install PHPUnit
  
  # Set channels to autodiscover.
  exec {"pear auto_discover":
    command => "/usr/bin/pear config-set auto_discover 1",
    require => Package['php-pear']
  }
  
  exec {"pear update-channels":
    command => "/usr/bin/pear update-channels",
    require => Exec['pear auto_discover']
  }  
  
  # Install common dependencies first.
  
  exec {"pecl imagick":
  	command => "/usr/bin/pecl install imagick",
	require => Exec['pear update-channels']
	#returns => [ 0, '', ' ']
  }
  
  exec {"pecl uploadprogress":
  	command => "/usr/bin/pecl install uploadprogress",
	require => Exec['pear update-channels']
	#returns => [ 0, '', ' ']
  }  
  
  
  # Required by FinderFacade.
 # exec {"discover channel theseer":
 #   command => "/usr/bin/pear channel-discover pear.netpirates.net",
 #   require => Exec['pear update-channels']
 # }
  
  # Required by FinderFacade.
  exec {"pear install fDOMDocument":
    command => "/usr/bin/pear install -f --alldeps theseer/fDOMDocument",
    creates => '/usr/bin/phpunit',
    require => Exec['pear update-channels']
  }
  
  # Required by FinderFacade.
  exec {"pear install Finder":
    command => "/usr/bin/pear install -f --alldeps pear.symfony.com/Finder",
    creates => '/usr/bin/phpunit',
    require => Exec['pear update-channels']
  }
  
  # Required by phpcpd
  exec {"pear install FinderFacade":
    command => "/usr/bin/pear install -f --alldeps pear.phpunit.de/FinderFacade",
    creates => '/usr/bin/phpunit',
    require => Exec['pear update-channels']
  }
  
  
  
  

  exec {"pear install phpunit":
    command => "/usr/bin/pear install -f --alldeps pear.phpunit.de/PHPUnit",
    creates => '/usr/bin/phpunit',
    require => Exec['pear update-channels']
  }
  
  # install phploc
  exec {"pear install phploc":
    command => "/usr/bin/pear install --alldeps pear.phpunit.de/phploc",
    creates => '/usr/bin/phploc',
    require => Exec['pear update-channels']
  }
  
  # install phpcpd
  /* Disable phpcd for now.
  exec {"pear install phpcpd":
    command => "/usr/bin/pear install --alldeps pear.phpunit.de/phpcpd",
    creates => '/usr/bin/phpcpd',
#    require => Exec['pear install fDOMDocument']
	require => [
		#Group["fearme"],
		#Group["fearmenot"]
		Exec['pear update-channels'],
		Exec['pear install Finder'],
		Exec['pear install FinderFacade'],
		Exec['pear install fDOMDocument']
	]	
  }
  */
  
  # install phpdcd
  exec {"pear install phpdcd":
    command => "/usr/bin/pear install --alldeps pear.phpunit.de/phpdcd-beta",
    creates => '/usr/bin/phpdcd',
    require => Exec['pear update-channels']
  }

  # install phpcs
  exec {"pear install phpcs":
    command => "/usr/bin/pear install --alldeps PHP_CodeSniffer",
    creates => '/usr/bin/phpcs',
    require => Exec['pear update-channels']
  }

  # install phpdepend
  exec {"pear install pdepend":
    command => "/usr/bin/pear install --alldeps pear.pdepend.org/PHP_Depend-beta",
    creates => '/usr/bin/pdepend',
    require => Exec['pear update-channels']
  }

  # install phpmd
  exec {"pear install phpmd":
    command => "/usr/bin/pear install --alldeps pear.phpmd.org/PHP_PMD",
    creates => '/usr/bin/phpmd',
    require => Exec['pear update-channels']
  }

  # install PHP_CodeBrowser
  exec {"pear install PHP_CodeBrowser":
    command => "/usr/bin/pear install --alldeps pear.phpqatools.org/PHP_CodeBrowser",
    creates => '/usr/bin/phpcb',
    require => Exec['pear update-channels']
  }      

}
