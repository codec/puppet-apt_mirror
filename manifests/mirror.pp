#
define apt_mirror::mirror (
  $mirror,
  $os         = 'ubuntu',
  $release    = ['precise'],
  $components = ['main', 'contrib', 'non-free'],
  $source     = false,
  $arch       = [$::architecture]
) {

  concat::fragment { $name:
    target  => '/etc/apt/mirror.list',
    content => template('apt_mirror/mirror.erb'),
    order   => '02',
  }

}
