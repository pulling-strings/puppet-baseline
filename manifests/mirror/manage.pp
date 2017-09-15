# Mirror switch management
class baseline::mirror::manage {
    file{"${::baseline::home}/bin/":
      ensure => directory,
    } ->

    file { "${::baseline::home}/bin/au-mirror":
      ensure  => file,
      mode    => '0644',
      source  => 'puppet:///modules/baseline/au-mirror',
      owner   => root,
      group   => root,
      require => File["${::baseline::home}/bin/"]
    }

    file { "${::baseline::home}/bin/local-mirror":
      ensure  => file,
      mode    => '0644',
      source  => 'puppet:///modules/baseline/local-mirror',
      owner   => root,
      group   => root,
      require => File["${::baseline::home}/bin/"]
    }

    file { '/etc/apt/source.list_au':
      ensure  => file,
      mode    => '0644',
      content => template('baseline/sources.list.erb'),
      owner   => root,
      group   => root,
    }

    file{'/etc/apt/source.list.d_au':
      ensure => directory,
    }
}
