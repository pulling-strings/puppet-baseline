# Setting up ilarchive
class baseline::ilarchive {
  include apt::update
  replace { '/etc/apt/sources.list':
    file        => '/etc/apt/sources.list',
    pattern     => 'be.archive',
    replacement => 'il.archive',
    notify      => Exec['apt_update'],
  }

  Replace['/etc/apt/sources.list'] -> Package<||>
  Exec['apt_update']-> Package<||>
}
