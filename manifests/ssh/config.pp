# Misc ssh_config settings
class baseline::ssh::config($user,$proxies=[]){
  $path = "${baseline::home}/.ssh/config"

  concat{$path:
    owner   => $user,
    group   => $user,
    require => File["${baseline::home}/.ssh"],
  }


  concat::fragment{ 'base-config':
    target => $path,
    source => 'puppet:///modules/baseline/ssh_config',
  }


  if ($proxies != []){
    create_resources(baseline::ssh::proxy,$proxies)
  }

}
