# Setting up authorized_keys for a specific user
# It requires the user and its home folder creation
define baseline::ssh::keys {

  $keys = hiera('baseline::ssh::keys')

  ensure_resource('file', "/home/${name}/.ssh/", {
    ensure => 'directory',
    owner  => $name,
    group  => $name,
    require  => [File["/home/${name}"],User[$name]]
  })

  file { "/home/${name}/.ssh/authorized_keys":
    ensure  => file,
    mode    => '0644',
    content => template('baseline/authorized_keys.erb'),
    owner   => $name,
    group   => $name,
    require => File["/home/${name}/.ssh/"]
  }
}
