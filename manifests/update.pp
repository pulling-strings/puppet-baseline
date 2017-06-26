# enabling remote apt-get upgrade via a special upgrade only user
class baseline::update($user='upgrade') {

  baseline::ssh::keys{$user: }

  user{ $user:
    ensure  => present,
    comment => 'an upgrade only user',
    home    => "/home/${user}"
  } ->

  file{"/home/${user}":
    ensure => directory,
    owner  => $user,
    group  => $user
  }

  if $::kernel == 'Linux' {
    $sudoer = '/etc/sudoers.d/upgrade'

    $update = '/usr/bin/apt update'
    $upgrade = '/usr/bin/apt upgrade -y'
    $cleanup = '/usr/bin/apt-cleanup'
    $purge = '/usr/bin/purge-kernels'
    $install = '/usr/bin/apt install * -y'
    $puppet = '/bin/bash run.sh *'

    file { $sudoer:
      content => "${user} ALL=NOPASSWD: ${update}, ${upgrade}, ${purge}, ${cleanup}, ${install}\n",
    }

    file { '/usr/bin/purge-kernels':
      ensure => file,
      mode   => '+x',
      source => 'puppet:///modules/baseline/purge-kernels',
      owner  => root,
      group  => root,
    }

    file { '/usr/bin/apt-cleanup':
      ensure => file,
      mode   => '+x',
      source => 'puppet:///modules/baseline/apt-cleanup',
      owner  => root,
      group  => root,
    }
  } elsif $::kernel == 'FreeBSD' {
    $sudoer = '/usr/local/etc/sudoers.d/upgrade'

    file { $sudoer:
      ensure  => present,
      content => "${user} ALL=NOPASSWD:/usr/local/bin/pc-updatemanager *\n"
    }
  }

}
