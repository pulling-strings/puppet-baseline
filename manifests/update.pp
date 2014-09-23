# enabling remote apt-get upgrade via a special upgrade only user
class baseline::update($user=false, $keys=[]) {
  validate_string($user)

  user{$user:
    ensure      => present,
    comment     => 'an upgrade only user',
    managehome  => true,
    home        => "/home/${user}"
  } ->

  file{"/home/${user}/.ssh/":
    ensure  => directory,
    owner   => $user,
    group   => $user,
  } ->

  file { "/home/${user}/.ssh/authorized_keys":
    ensure  => file,
    mode    => '0644',
    content => template('baseline/upgrade_keys.erb'),
    owner   => $user,
    group   => $user,
  } ->

  file{'/etc/sudoers.d/upgrade':
    ensure => present
  } ->

  file_line { 'add passwordless update purge':
    path => '/etc/sudoers.d/upgrade',
    line => "${user} ALL=NOPASSWD: /usr/bin/apt-get update, /usr/bin/apt-get upgrade -y, /usr/bin/purge-kernels"
  }

  file_line { 'remove sudoers file passwordless update':
    ensure => absent,
    path   => '/etc/sudoers',
    line   => "${user} ALL=NOPASSWD: /usr/bin/apt-get update, /usr/bin/apt-get upgrade -y"
  }

  file { '/usr/bin/purge-kernels':
    ensure=> file,
    mode  => '+x',
    source=> 'puppet:///modules/baseline/purge-kernels',
    owner => root,
    group => root,
  }
}
