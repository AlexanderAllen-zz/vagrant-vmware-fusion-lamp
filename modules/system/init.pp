class system {
	$packages = [
		'curl', 'vim', 'openssl', 'ncurses-devel', 'pcre-devel',
		'ImageMagick', 'ImageMagick-devel'
	]
    
  package { $packages:
    ensure => present,
    require => Exec["yum update"]
  }
}