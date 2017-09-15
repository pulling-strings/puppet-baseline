# Local apt mirror
class baseline::mirror(
  $src     = 'us.archive.ubuntu.com',
  $security = 'security.ubuntu.com',
  $partner = 'archive.canonical.com',
  $disable = false
) {

  if $disable != true {
    include baseline::mirror::manage

    # http://bit.ly/2n9xAod
    file{'/etc/apt/apt.conf.d/50appstream':
      ensure => absent
    } -> Class['apt']

    ensure_resource('class', '::apt', {purge => {'sources.list' => true}})

    apt::source{$::lsbdistcodename:
      location => "http://${src}/ubuntu/",
      release  => $::lsbdistcodename,
      repos    => 'main restricted universe multiverse',
      include  => {
        src => false,
        deb => true
      },
    }

    apt::source{"${::lsbdistcodename}-updates":
      location => "http://${src}/ubuntu/",
      release  => "${::lsbdistcodename}-updates",
      repos    => 'main restricted universe multiverse',
      include  => {
        src => false,
        deb => true
      },
    }

    apt::source{"${::lsbdistcodename}-backports":
      location => "http://${src}/ubuntu/",
      release  => "${::lsbdistcodename}-backports",
      repos    => 'main restricted universe multiverse',
      include  => {
        src => false,
        deb => true
      },

    }

    if $security == 'security.ubuntu.com' {
      $suffix = 'ubuntu'
    } else { # local mirror
      $suffix = 'ubuntu-security'
    }

    apt::source{"${::lsbdistcodename}-security":
      location => "http://${security}/${suffix}/",
      release  => "${::lsbdistcodename}-security",
      repos    => 'main restricted universe multiverse',
      include  => {
        src => false,
        deb => true
      },
    }

    apt::source{"${::lsbdistcodename}-extras":
      location => "http://${partner}/ubuntu/",
      release  => $::lsbdistcodename,
      repos    => 'partner',
      include  => {
        src => false,
        deb => true
      },
    }


  } else {
    exec{'purge mirror':
      command => "rm -f /etc/apt/sources.list.d/${$::lsbdistcodename}*",
      user    => 'root',
      path    => '/bin',
    } -> Exec['apt_update']


    file { '/etc/apt/source.list':
      ensure  => file,
      mode    => '0644',
      content => template('baseline/sources.list.erb'),
      owner   => root,
      group   => root,
    }
  }
}
