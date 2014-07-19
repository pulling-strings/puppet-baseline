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

  file_line { 'add passwordless update':
    path => '/etc/sudoers',
    line => "${user} ALL=NOPASSWD: /usr/bin/apt-get update, /usr/bin/apt-get upgrade -y"
  }
}
