# baseline tools and package for a working secured system.
class baseline($home=false) {
  validate_string($home)
  include ::baseline::security
  include ::baseline::networking
  include ::baseline::filesystem

  if defined('timezone') {
    package{'debconf-utils':
      ensure  => present
    }
  }
}
