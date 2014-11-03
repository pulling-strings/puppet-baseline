# SSH hardening see:
#  http://bodhizazen.net/Tutorials/SSH_security 
class baseline::hardening($user,$strict=false,$allowed_host='') {
  file_line { 'disable ssh protocol 1':
    path => '/etc/ssh/ssh_config',
    line => 'Protocol 2'
  }

  file_line {'Disable password auth' :
    path => '/etc/ssh/ssh_config',
    line => 'PasswordAuthentication no'
  }

  file_line {'Allow only single ssh user' :
    path => '/etc/ssh/ssh_config',
    line => "AllowUsers ${user}"
  }

  file_line {'Dont allow root ssh' :
    path => '/etc/ssh/ssh_config',
    line =>  'PermitRootLogin no'
  } ~> Service['ssh']

  ensure_resource('service', 'ssh', {})

  if($strict){
    file_line {'No tcp forwarding' :
      path => '/etc/ssh/ssh_config',
      line => 'AllowTcpForwarding no'
    }

    file_line {'No X11 forwarding' :
      path => '/etc/ssh/ssh_config',
      line => 'X11Forwarding no'
    }

    file_line {'Strict file mode checks' :
      path => '/etc/ssh/ssh_config',
      line => 'StrictModes yes'
    }

    include ufw

    if($allowed_host != ''){
      File_Line['Prevent SSH bruth force'] ->

      file_line { 'Allow host':
        path  => '/etc/ufw/before.rules',
        line  => "iptables -A INPUT -p tcp -s ${allowed_host} --dport ssh -j ACCEPT",
        after => "\# don't delete the 'COMMIT' line or these rules won't be processed"
       }
    }

    file_line { 'Pass SSH':
      path  => '/etc/ufw/before.rules',
      line  => '-A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT',
      after => "\# don't delete the 'COMMIT' line or these rules won't be processed"
    } ->

    file_line { 'Prevent SSH bruth force':
      path  => '/etc/ufw/before.rules',
      line  => '-A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 120 --hitcount 8 --rttl --name SSH -j DROP',
      
      after => "\# don't delete the 'COMMIT' line or these rules won't be processed"
    } ->

    file_line { 'Mark ssh packets':
      path    => '/etc/ufw/before.rules',
      line    => '-A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name SSH',
      after   => "\# don't delete the 'COMMIT' line or these rules won't be processed",
      notify => Service['ufw']
    } -> Exec['ufw-enable']
    
  }
}
