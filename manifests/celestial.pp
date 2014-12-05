# Enabling remote Celesital Puppet run
class baseline::celestial(
  $user='celestial',
  $args=''
) {

  baseline::ssh_keys{$user: }

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

  file{'/etc/sudoers.d/celestial':
    ensure => present
  } ->

  file_line { 'Celestial Puppet run':
    path => '/etc/sudoers.d/celestial',
    line => "${user} ALL=NOPASSWD: /tmp/*/scripts/run.sh ${args} --detailed-exitcodes"
  }

}
