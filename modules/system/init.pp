class system {
	$packages = [
		'curl',
    #'vim', 'openssl', 'ncurses-devel', 'pcre-devel',
		#'ImageMagick', 'ImageMagick-devel'
	]
    
  package { $packages:
    ensure => present,
  }
  
  # Customize default Hiera values.
  # http://docs.puppetlabs.com/hiera/1/configuring.html
  
	file { '/var/lib/hiera/common.yaml':
		source => 'puppet:///modules/system/common.yaml',
		owner => 'root',
		group => 'root',
    ensure => 'file'
  }    
  
}