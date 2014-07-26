# a collection of filesystem tools and settings
class baseline::filesystem($ssds=[]){

  package{'gt5':
    ensure  => present
  }

  package{'dtrx':
    ensure  => present
  }

  if(!empty($ssds)){
    file { '/etc/cron.daily/trim':
      ensure  => file,
      mode    => '0700',
      content => template('baseline/trim.erb'),
      owner   => root,
      group   => root,
    }
  }

  package{'btrfs-tools':
    ensure  => present
  }
}
