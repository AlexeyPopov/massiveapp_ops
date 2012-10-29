class apache2 {
    package {
      "apache2" :
          ensure => present,
          before => File["/etc/apache2/apache2.conf"]
    }
    service {
      "apache2" :
          ensure => true,
          enable => true,
          subscribe => File["/etc/apache2/apache2.conf"]
    }
    file {
      "/etc/apache2/apache2.conf" :
          source => "puppet:///modules/apache2/apache2.conf",
          mode => 644,
          owner => root,
          group => root;
      "/etc/apache2/sites-enabled/massiveapp.conf":
          source  => "puppet:///modules/apache2/massiveapp.conf",
          owner   => root,
          group   => root,
          notify  => Service["apache2"],
          require => Package["apache2"];
    }
    exec {
      "rm /etc/apache2/sites-enabled/000-default":
        user    => root,
        group   => root,
        require => Package["apache2"],
        notify  => Service["apache2"]
        #unless  => "ls /etc/apache2/sites-enabled/000-default"
    }
    exec {
      "/usr/bin/apt-get update":
        user    => root,
        group   => root,
        before  => [Package["apache2"], Exec["install_passenger"]]
    }
}