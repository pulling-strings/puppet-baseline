# Basic neworking utilities
class baseline::networking($user){

  package{['sshuttle','wakeonlan','nmap','aria2']:
    ensure  => present
  }

  ensure_resource('file', "${baseline::home}/.ssh", {'ensure' => 'directory'})

  file{"${baseline::home}/.ssh/config":
    source  => 'puppet:///modules/baseline/ssh_config',
    require => File["${baseline::home}/.ssh"],
    owner   => $user,
    group   => $user
  }
}
