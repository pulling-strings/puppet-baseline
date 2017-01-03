# Setting up custom apt archive
class baseline::customarchive(
  $new = 'il'
){
  replace { '/etc/apt/sources.list':
    file        => '/etc/apt/sources.list',
    pattern     => 'us.archive',
    replacement => "${new}.archive",
    notify      => Exec['apt_update'],
  }

  Replace['/etc/apt/sources.list'] -> Package<||>
}
