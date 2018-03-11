# ulimits
class baseline::limit {
  # Dockerized Elasticsearch
  file_line { 'max-map-count':
    path => '/etc/sysctl.conf',
    line => 'vm.max_map_count = 262144'
  }
}
