class yrsbadger(
  $domain,
  $mysql_root_password,
  $mysql_database,
  $mysql_user,
  $mysql_password,
  $email_host,
  $email_user,
  $email_password,
  $django_secret_key,
  $git_url = 'git://github.com/robyoung/yrsbadger.git',
) {
  $user        = 'deploy'
  $group       = 'deploy'
  $app_port    = 8081
  $app_path    = "/var/www/$domain"
  $virtualenv_path = "$app_path/venv"

  include yrsbadger::setup
  include yrsbadger::mysql
  include yrsbadger::app
  include yrsbadger::serve

  Class['yrsbadger::setup'] ->
  Class['yrsbadger::mysql'] ->
  Class['yrsbadger::app'] ->
  Class['yrsbadger::serve']
}
