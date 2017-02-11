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
}
