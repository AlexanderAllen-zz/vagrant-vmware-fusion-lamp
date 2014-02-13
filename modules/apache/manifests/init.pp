class apache {

  package { "httpd":
    ensure => present
  }

  file { '/etc/httpd/conf.d/custom.conf':
    source => 'puppet:///modules/apache/custom.conf',
    owner => 'root',
    group => 'root',
    require => Package['httpd']
  }

  # Ensure vhosts.d exists.
  file { '/etc/httpd/vhosts.d':
    ensure => 'directory',
    owner => 'root',
    group => 'root',
    require => Package['httpd']
  }

  file { '/etc/httpd/vhosts.d/default.conf':
    source => 'puppet:///modules/apache/default.conf',
    owner => 'root',
    group => 'root',
    require => Package['httpd']
  }

  # Comment out deafult Listen directive on /etc/httpd/conf/httpd.conf.
  # sed -ir 's/^Listen\s80/#Listen 80/g'
  #exec { 'Update /etc/httpd/conf/httpd.conf':
  #command => "sed -ir 's/^Listen\s80/#Listen 80/g'",
  #require => Package["httpd"]
 # }

  # Ensure httpd is running.
  service {
    "httpd":
    ensure => running,
    require => Package["httpd"]
  }


}
