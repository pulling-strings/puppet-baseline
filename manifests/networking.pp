# Basic neworking utilities
class baseline::networking(){

  package{['sshuttle','nmap']:
    ensure  => present
  }


  package{['aria2', 'wakeonlan']:
    ensure  => absent
  }
}
