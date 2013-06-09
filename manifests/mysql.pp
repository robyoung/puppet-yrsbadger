# Install MySQL and create the app database
class yrsbadger::mysql {

  class {'::mysql':}
  class {'::mysql::server':
    config_hash => {
      'root_password' => $yrsbadger::mysql_root_password,
    }
  }

  package {'libmysqlclient-dev':
    ensure => present,
    require => Class['::mysql'],
  }

  mysql::db { $yrsbadger::mysql_database:
    user     => $yrsbadger::mysql_user,
    password => $yrsbadger::mysql_password,
    host     => 'localhost',
    grant    => ['all'],
  }
}