# Setting up authorized_keys for a specific user
# It requires the user and its home folder creation
define baseline::ssh_keys {

  $keys = hiera('baseline::ssh_keys')

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
    owner   => root,
    group   => root,
    require => File["/home/${name}/.ssh/"]
  }
}
