# Cleaning up services
class baseline::services {
  if($::operatingsystem == 'Ubuntu'){
    service{['accounts-daemon']:
      ensure    => stopped,
      enable    => false,
      provider  => systemd,
      hasstatus => true,
    }
    if($::virtual != 'virtualbox'){
      service{['vboxadd-service', 'vboxadd-x11', 'vboxadd']:
        ensure    => stopped,
        enable    => false,
        provider  => systemd,
        hasstatus => true,
      }
    }
  }
}
