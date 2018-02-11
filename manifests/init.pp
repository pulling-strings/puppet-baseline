# baseline tools and package for a working secured system.
class baseline(
  String $home=''
) {
  include ::baseline::networking
  include ::baseline::filesystem
  include ::baseline::services

  if defined('timezone') {
    ensure_packages(['debconf-utils'],{})
  }
}
