class etherpad-legacy {
    file { "/home/etherpad":
        require => User[etherpad],
        owner => etherpad,
        group => etherpad,
        mode  => 775,
        recurse=> false,
        ensure => directory;
    }

    file { "/home/etherpad/dev":
        require => File["/home/etherpad"],
        owner => etherpad,
        group => etherpad,
        mode  => 775,
        recurse=> false,
        ensure => directory;
    }

    user { "etherpad":
        ensure => "present",
        uid => "10000",
        shell => "/bin/bash",
        managehome => true;
    }

    exec { "/usr/bin/apt-get update":
        alias => "apt-get-update";
    }   

    package { ["curl", "scala", "openjdk-6-jdk", "libmysql-java",
               "mysql-server", "openoffice"]:
        require => Exec["apt-get-update"],
        ensure => "installed";
    }

    group { "puppet":
        ensure => "present",
    }
}
