# Security tools
class baseline::security {
  package{'pwgen':
    ensure => present
  }

  package{'sshfs':
    ensure => present
  }

  apt::ppa{'ppa:stefansundin/truecrypt':} ->

  package{'truecrypt':
    ensure  => present
  }
}
