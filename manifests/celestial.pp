# Enabling remote Celesital Puppet run
class baseline::celestial(
  $user='celestial',
  $args=''
) {

  baseline::ssh_keys{$user: }

  $sudoers= $::osfamily ? {
    'Debian'   => '/etc/sudoers.d',
    'FreeBSD'  => '/usr/local/etc/sudoers.d'
  }

  user{ $user:
    ensure  => present,
    comment => 'A Celestial only user',
    home    => "/home/${user}"
  } ->

  file{"/home/${user}":
    ensure => directory,
    owner  => $user,
    group  => $user
  }

  file{"${sudoers}/celestial":
    ensure => present
  } ->

  file_line { 'Celestial Puppet run':
    path => "${sudoers}/celestial",
    line => "${user} ALL=NOPASSWD: /tmp/*/scripts/run.sh ${args} --detailed-exitcodes"
  }

}
