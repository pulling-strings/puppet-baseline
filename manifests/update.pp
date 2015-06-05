# enabling remote apt-get upgrade via a special upgrade only user
class baseline::update($user='upgrade') {

  baseline::ssh::keys{$user: }

  user{ $user:
    ensure      => present,
    comment     => 'an upgrade only user',
    home        => "/home/${user}"
  } ->

  file{"/home/${user}":
     ensure => directory,
     owner  => $user,
     group  => $user
  }

  if $kernel == 'Linux' {
    $sudoer = '/etc/sudoers.d/upgrade'

    file_line { 'add passwordless update purge':
     path    => $sudoer,
     line    => "${user} ALL=NOPASSWD: /usr/bin/apt-get update, /usr/bin/apt-get upgrade -y, /usr/bin/purge-kernels",
     require => File[$sudoer]
    }

    file { '/usr/bin/purge-kernels':
      ensure=> file,
      mode  => '+x',
      source=> 'puppet:///modules/baseline/purge-kernels',
      owner => root,
      group => root,
    }
  } elsif $kernel == 'FreeBSD' {
    $sudoer = '/usr/local/etc/sudoers.d/upgrade'

    file_line { 'add passwordless update purge':
     path    => $sudoer,
     line    => "${user} ALL=NOPASSWD:  /usr/local/bin/pc-updatemanager *"
     require => File[$sudoer]
    }
  }

  file $sudoer {:
    ensure => present
  }
}
