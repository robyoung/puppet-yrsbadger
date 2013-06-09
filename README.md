# puppet-yrsbadger


A puppet module for setting up the [Young Rewired State badge server](https://github.com/robyoung/yrsbadger).

## Usage

```puppet
class {'yrsbadger':
  domain              => 'badges.example.com',
  mysql_root_password => 'root password',
  mysql_database      => 'badger',
  mysql_user          => 'badger',
  mysql_password      => 'password',
  email_host          => 'smtp.example.com',
  email_user          => 'badger',
  email_password      => 'password',
  django_secret_key   => 'foo bar monkey'
}
```