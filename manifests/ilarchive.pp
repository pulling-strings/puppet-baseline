# Setting up ilarchive
class baseline::ilarchive {
  replace { '/etc/apt/sources.list':
    file        => '/etc/apt/sources.list',
    pattern     => 'us.archive',
    replacement => 'il.archive',
    notify      => Exec['apt_update'],
  }

  Replace['/etc/apt/sources.list'] -> Package<||>
}
