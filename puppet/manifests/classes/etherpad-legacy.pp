class etherpad-legacy {

    file { "/home/etherpad":
        require => User[etherpad],
        owner => etherpad,
        group => etherpad,
        mode  => 775,
        recurse=> false,
        ensure => directory;
    }

    file { "/home/etherpad/src":
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

    package { ["git-core", "curl", "scala", "openjdk-6-jdk", "libmysql-java",
               "mysql-server", "openoffice.org", "firefox", "xvfb", "python-virtualenv",
               "python-pip"]:
        require => Exec["apt-get-update"],
        ensure => "latest";
    }

    exec { "/usr/bin/git clone git://github.com/mozilla/pad.git":
        alias => "git-clone",
        creates => "/home/etherpad/src/pad",
        user => "etherpad",
        require => [File["/home/etherpad/src"], Package["git-core"]],
        cwd => "/home/etherpad/src";
    }

    exec { "/home/etherpad/src/pad/bin/build.sh":
        alias => "build",
        user => "etherpad",
        require => Exec["git-clone"];
    }

    file { "/home/etherpad/src/pad/etherpad/etc/etherpad.local.properties":
        owner => "etherpad",
        source => "/vagrant/puppet/files/etherpad.local.properties",
        require => Exec["git-clone"];
    }

    exec { "/bin/echo 'CREATE DATABASE IF NOT EXISTS etherpad' | /usr/bin/mysql":
        alias => "create-db",
        user => "root",
        require => Package["mysql-server"];
    }

    exec { "/bin/echo 'GRANT ALL ON etherpad.* TO etherpad@localhost IDENTIFIED BY \"password\"' | /usr/bin/mysql":
        user => "root",
        require => Exec["create-db"];
    }

    group { "puppet":
        ensure => "present",
    }
}
