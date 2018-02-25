# Setting up osquery
class baseline::osquery {
    apt::source{'osquery':
      include      => {
        src => false,
        deb => true
      },
      key          => {
        id     => '1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B',
        server => 'keyserver.ubuntu.com'
      },
      location     => 'https://osquery-packages.s3.amazonaws.com/xenial',
      architecture => 'amd64',
      release      => 'xenial',
      repos        => 'main',
    }

    -> package{'osquery':
      ensure  => present,
      require => Class['apt::update']
    }
}
