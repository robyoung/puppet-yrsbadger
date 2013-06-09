# Install and set up the app
class yrsbadger::app {
  # variables for template
  $email = {
    'host' => $yrsbadger::email_host,
    'user' => $yrsbadger::email_user,
    'password' => $yrsbadger::email_password,
  }
  $mysql = {
    'database' => $yrsbadger::mysql_database,
    'user'     => $yrsbadger::mysql_user,
    'passwowd' => $yrsbadger::mysql_password,
  }
  $django = {
    'secret_key' => $yrsbadger::django_secret_key,
  }

  # Clone the application
  vcsrepo {$yrsbadger::app_path:
    ensure   => latest,
    provider => git,
    source   => $yrsbadger::git_url,
    revision => 'master',
    user     => $yrsbadger::user,
  }

  # Install the production configuration
  file { "$yrsbadger::app_path/yrsbadger/settings_local.py":
    ensure  => present,
    owner   => $yrsbadger::user,
    group   => $yrsbadger::group,
    content => template('yrsbadger/settings_local.py'),
    require => Vcsrepo[$yrsbadger::app_path],
  }

  # Set up the virtualenv
  python::virtualenv { $yrsbadger::virtualenv_path:
    ensure     => present,
    version    => '2.7',
    systempkgs => false,
    distribute => false,
    owner      => $yrsbadger::user,
    group      => $yrsbadger::group,
    require    => Vcsrepo[$yrsbadger::app_path],
  }

  # Install application requirements
  python::requirements {"$yrsbadger::app_path/requirements.txt":
    virtualenv => $yrsbadger::virtualenv_path,
    owner      => $yrsbadger::user,
    group      => $yrsbadger::group,
    require    => Python::Virtualenv[$yrsbadger::virtualenv_path],
  }
  # Install the additional MySQL dependency
  python::pip {"MySQL-python==1.2.3c1":
    virtualenv => $yrsbadger::virtualenv_path,
    require    => Python::Virtualenv[$yrsbadger::virtualenv_path],
  }

  # Sync the database
  exec { "syncdb $yrsbadger::app_name":
    command   => 'python manage.py syncdb --noinput',
    path      => "$yrsbadger::virtualenv_path/bin",
    cwd       => $yrsbadger::app_path,
    require   => [Python::Pip["MySQL-python==1.2.3c1"], Python::Requirements["$yrsbadger::app_path/requirements.txt"]],
    subscribe => [Vcsrepo[$yrsbadger::app_path], File["$yrsbadger::app_path/yrsbadger/settings_local.py"]],
  }
}