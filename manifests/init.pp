#
class apt_mirror (
  $ensure    = present,
  $enabled   = true,
  $base_path = '/var/spool/apt-mirror',
  $nthreads  = 20,
  $tilde     = 0
) {

  include concat::setup

  package { 'apt-mirror':
    ensure => $ensure,
  }

  file { $base_path:
    ensure  => $enabled ? { false => absent, default => directory },
    owner   => 'apt-mirror',
    require => Package['apt-mirror'],
  }

  concat { '/etc/apt/mirror.list':
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  concat::fragment { 'mirror.list header':
    target  => '/etc/apt/mirror.list',
    content => template('apt_mirror/header.erb'),
    order   => '01',
  }

  cron { 'apt-mirror':
    ensure  => $enabled ? { false => absent, default => present },
    user    => 'root',
    command => '/usr/bin/apt-mirror /etc/apt/mirror.list',
    minute  => 0,
    hour    => 4,
    require => File[$base_path],
  }

}
