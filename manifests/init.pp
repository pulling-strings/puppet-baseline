# baseline tools and package for a working secured system.
class baseline {
  include security
  include networking
  include filesystem

  package{'mercurial': ensure  => present }
}
