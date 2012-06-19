class etherpad-legacy {
    file { "/home/vagrant/jenkins.sh":
        owner => vagrant,
        source => '/vagrant/puppet/files/jenkins.sh';
    }

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
               "mysql-server", "openoffice.org", "firefox", "xvfb"]:
        require => Exec["apt-get-update"],
        ensure => "latest";
    }

    exec { "/usr/bin/git clone git://github.com/mozilla/pad.git":
        creates => "/home/etherpad/src/pad",
        user => "etherpad",
        require => [File["/home/etherpad/src"], Package["git-core"]],
        cwd => "/home/etherpad/src";
    }

    file { "/home/etherpad/src/pad/etherpad/etc/etherpad.localdev.properties":
        owner => etherpad,
        source => '/vagrant/puppet/files/etherpad.localdev.properties';
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
