# Security tools
class baseline::security {
  package{'pwgen':
    ensure => present
  }

  package{'sshfs':
    ensure => present
  }

  package{'rng-tools':
    ensure  => present
  }

  package{'veracrypt':
    ensure  => present,
    require => [Apt::Source['barbecue'], Class['apt::update']]
  }

  package{'pass':
    ensure  => present
  }
}
