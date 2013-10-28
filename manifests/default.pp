group{ 'puppet': ensure  => present }

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

node default {
  include java
  include wget
  include deploy
  class { 'apt': always_apt_update => true }

  class { 'mysql::server':
    override_options => { 'mysqld' => { 'max_connections' => '1024',
                                        'transaction-isolation' => 'READ-COMMITTED',
                                        'default-storage-engine' => 'InnoDB'
    } }
  }

  mysql::db { 'crowd':
    user     => 'crowdadm',
    password => 'mypassword',
    host     => 'localhost',
    charset => 'utf8',
    collate => 'utf8_bin',
    grant    => ['SELECT','INSERT','UPDATE','DELETE','CREATE','DROP','ALTER','INDEX'],
  }

  mysql::db { 'crowdiddb':
    user     => 'idcrowdadm',
    password => 'mypassword',
    host     => 'localhost',
    charset => 'utf8',
    grant    => ['SELECT','INSERT','UPDATE','DELETE','CREATE','DROP','ALTER','INDEX'],
  }

  class {'crowd':}

}
