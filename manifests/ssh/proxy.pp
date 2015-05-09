# Proxy definition
define baseline::ssh::proxy(
  $proxy,
  $port,
  $user,
  $key
) {
  
  concat::fragment{ 'proxies':
    target  => $baseline::ssh::config::path,
    content => template('baseline/ssh_proxy.erb'),
  }

}
