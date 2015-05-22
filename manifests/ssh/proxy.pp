# Proxy definition
define baseline::ssh::proxy(
  $proxy,
  $port,
  $user,
  $key
) {
  
  concat::fragment{ "${name}-proxy":
    target  => $baseline::ssh::config::path,
    content => template('baseline/ssh_proxy.erb'),
  }

}
