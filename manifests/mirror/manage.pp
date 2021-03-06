# Mirror switch management
class baseline::mirror::manage(
  $region = 'au'
){
    file{"${::baseline::home}/bin/":
      ensure => directory,
    }

    -> file { "${::baseline::home}/bin/au-mirror":
      ensure  => file,
      mode    => 'u+x',
      source  => 'puppet:///modules/baseline/au-mirror',
      owner   => root,
      group   => root,
      require => File["${::baseline::home}/bin/"]
    }

    file { "${::baseline::home}/bin/local-mirror":
      ensure  => file,
      mode    => 'u+x',
      source  => 'puppet:///modules/baseline/local-mirror',
      owner   => root,
      group   => root,
      require => File["${::baseline::home}/bin/"]
    }

    file { '/etc/apt/sources.list_au':
      ensure  => file,
      mode    => 'u+x',
      content => template('baseline/sources.list.erb'),
      owner   => root,
      group   => root,
    }

    file{'/etc/apt/source.list.d_au':
      ensure => directory,
    }
}
