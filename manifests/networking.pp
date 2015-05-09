# Basic neworking utilities
class baseline::networking(){

  package{['sshuttle','wakeonlan','nmap','aria2']:
    ensure  => present
  }

}
