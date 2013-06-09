# Serve the django application through Gunicorn and Nginx
class yrsbadger::serve {
  $app_port = $yrsbadger::app_port
  $log_path = $yrsbadger::log_path
  $domain = $yrsbadger::domain
  $virtualenv_path = $yrsbadger::virtualenv_path
  $gunicorn_config = "/etc/$domain/gunicorn"

  class {'nginx':}
  nginx::resource::upstream {'badger_app':
    ensure => present,
    members => ["localhost:$app_port"],
  }
  nginx::resource::vhost {$yrsbadger::domain:
    ensure => present,
    proxy  => 'http://badger_app',
  }

  file { "/etc/$domain":
    ensure => directory,
    owner   => $yrsbadger::user,
    group   => $yrsbadger::group,
  }

  file { $gunicorn_config:
    ensure  => present,
    owner   => $yrsbadger::user,
    group   => $yrsbadger::group,
    content => template('yrsbadger/gunicorn.erb'),
    require => File["/etc/$domain"],
  }

  include 'upstart'
  upstart::job { 'yrsbadger':
      description   => "YRS Badge Server",
      respawn       => true,
      respawn_limit => '5 10',
      user          => $yrsbadger::user,
      group         => $yrsbadger::group,
      exec          => "$virtualenv_path/bin/gunicorn -c $gunicorn_config yrsbadger.wsgi",
      chdir         => $yrsbadger::app_path,
      require       => [Class['yrsbadger::app'], File[$gunicorn_config]],
  }
}