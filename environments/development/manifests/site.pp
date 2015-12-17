#
# Basic stuff: Ensure puppet installation
#
group { 'puppet': ensure => 'present' }

#
# Basic stuff: Set default path
#
Exec { path => ['/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/'] }

#
# Base config
#
# This is the bootstrap class which will update the
# installation and set up all required main
# applications:
# - vim
# - curl
# - git
# - nodejs (latest was 5.3)
#
class baseconfig {

  # Start with a system update
  exec { 'applications-get update':
    command => 'apt-get update',
  }

  # Install all required packages
  package { ['vim', 'curl', 'build-essential', 'python', 'git-core', 'htop',
             'tree']:
    ensure => present,
  }

  # Install latest node, npm (the dirty way)
  exec { 'update node packages':
    command => 'curl -sL https://deb.nodesource.com/setup_5.x | bash -'
  }
  exec { 'install latest node':
    command => 'apt-get install -y nodejs'
  }

  # Set motd
  file { '/etc/motd':
    ensure => present,
    source => '/vagrant/environments/development/files/motd',
  }

}

#
# Apache
#
# Sets up a basic apache with one dev host. Make sure to
# update your /etc/hosts file with '192.168.56.150 dev.loc'
#
class apache {

  # Ensure apache
  package { ['apache2']:
    ensure => present;
  }

  # Run apache
  service { 'apache2':
    ensure  => running,
    require => Package['apache2'],
    subscribe => [
      File['/etc/apache2/mods-enabled/rewrite.load'],
      File['/etc/apache2/sites-available/dev.conf']
    ];
  }

  # Set up rewrite
  file { '/etc/apache2/mods-enabled/rewrite.load':
    ensure => link,
    target => '/etc/apache2/mods-available/rewrite.load',
    require => Package['apache2']
  }

  # Create apache vhost from local file
  file { '/etc/apache2/sites-available/dev.conf':
    ensure => present,
    source => '/vagrant/environments/development/files/dev.conf',
    require => Package['apache2'],
  }

  # Symlink vhost
  file { '/etc/apache2/sites-enabled/001-dev.conf':
    ensure => link,
    target => '/etc/apache2/sites-available/dev.conf',
    require => File['/etc/apache2/sites-available/dev.conf'],
    notify => Service['apache2'],
  }

}

#
# PHP
#
# Installs a basic PHP environment including the composer. To
# improve your debugging, please edit the date.timezone in:
# - /etc/php5/apache2/php.ini
# - /etc/php5/cli/php.ini
#
class php {

  # Install packages  
  package { ['php5', 'php5-cli', 'php5-mysql', 'php5-gd', 'php5-mcrypt', 'libapache2-mod-php5',
             'php5-imagick', 'php5-xdebug']:
    ensure => present,
  }

  # Install composer
  exec { 'install composer':
    command => 'curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer',
    require => Package['curl'],
  }

}

#
# MySQL
#
# Installs mysql with admin root/root
#
class mysql {

  # Install mysql server
  package { ['mysql-server', 'mysql-client']:
    ensure => present;
  }

  # Run mysql as service
  service { 'mysql':
    ensure  => running,
    require => Package['mysql-server'];
  }

  # Set username/password for dev
  exec { 'set mysql password':
    unless  => 'mysqladmin -uroot -proot status',
    command => "mysqladmin -uroot password root",
    path    => ['/bin', '/usr/bin'],
    require => Service['mysql'];
  }

}

include baseconfig, apache, php, mysql