# Set up packages, users and directories
class yrsbadger::setup {
  # Packages
  package {['curl', 'git', 'htop', 'vim']:
    ensure => present,
  }
  class { 'python':
    version    => '2.7',
    dev        => true,
    virtualenv => true,
  }

  # Users
  user { "$yrsbadger::user":
    ensure => present,
  }

  # Set up directories
  file { ['/var/www', $yrsbadger::log_path]:
    ensure  => directory,
    owner   => $yrsbadger::user,
    group   => $yrsbadger::group,
    require => User[$yrsbadger::user],
  }

}