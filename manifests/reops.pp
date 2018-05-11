# enabling remote apt-get upgrade via a special upgrade only user
class baseline::reops($user='re-ops') {

  baseline::ssh::keys{$user: }

  user{ $user:
    ensure  => present,
    comment => 'an re-ops only user',
    home    => "/home/${user}"
  }

  -> file{"/home/${user}":
    ensure => directory,
    owner  => $user,
    group  => $user
  }

  if $::kernel == 'Linux' {
    $sudoer = '/etc/sudoers.d/re-ops'

    $update  = '/usr/bin/apt update'
    $upgrade = '/usr/bin/apt upgrade -y'
    $cleanup = '/usr/bin/apt-cleanup'
    $purge   = '/usr/bin/purge-kernels'
    $install = '/usr/bin/apt install * -y'
    $ufw     = '/usr/sbin/ufw status'
    $puppet_code  = '/bin/bash run.sh --detailed-exitcodes --color=false'
    $puppet_args  = '/bin/bash run.sh --hiera_config * manifests/* '

    file { $sudoer:
      content => "${user} ALL=NOPASSWD: ${update}, ${upgrade}, ${purge}, ${cleanup}, ${install}, ${ufw}, ${puppet_code}, ${puppet_args}\n",
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
    $sudoer = '/usr/local/etc/sudoers.d/re-ops'

    file { $sudoer:
      ensure  => present,
      content => "${user} ALL=NOPASSWD:/usr/local/bin/pc-updatemanager *\n"
    }
  }

}
