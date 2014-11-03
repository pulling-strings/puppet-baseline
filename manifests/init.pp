# baseline tools and package for a working secured system.
class baseline($home=false) {
  validate_string($home)
  include hardening
  include security
  include networking
  include filesystem

  package{'mercurial': ensure  => present }
}
