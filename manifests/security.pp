# Security tools
class baseline::security($syslog_server='') {
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

  if(!empty($syslog_server)){
    # order matters!
    file_line { 'graylog2-rsyslog-template':
      path => '/etc/rsyslog.conf',
      line => '$template GRAYLOG2,"<%PRI%>1 %timegenerated:::date-rfc3339% %HOSTNAME% %syslogtag% - %APP-NAME%: %msg:::drop-last-lf%\n"'
    } ->

    file_line { 'action-forward-default':
      path => '/etc/rsyslog.conf',
      line => '$ActionForwardDefaultTemplate GRAYLOG2'
    } ->

    file_line { 'syslog-dest-server':
      path => '/etc/rsyslog.conf',
      line => "*.* @${syslog_server}"
    }
  }

}
