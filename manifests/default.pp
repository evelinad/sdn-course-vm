#-Global Execution params----

Exec {
          path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin:/usr/local/sbin:/sbin:/bin/sh",
          user => root,
          #logoutput => true,
}

#--apt-update Triggers-----

exec { "apt-update":
    command => "sudo apt-get update -y",
}

Exec["apt-update"] -> Package <| |> #This means that an apt-update command has to be triggered before any package is installed


Package { ensure => "installed" }

$essentials  = [ "build-essential", "fakeroot", "debhelper", "autoconf", "automake", "libssl-dev", "graphviz", "python-all", "python-qt4", "python-twisted-conch", "libtool", "tmux", "vim", "python-pip", "python-paramiko", "python-sphinx", "python-dev" , "ssh", "emacs", "sshfs", "python-routes", "bison", "git", "xterm", "firefox" ]

$pipPackages = [ "alabaster", "greenlet", "networkx" , "decorator", "eventlet", "msgpack-python", "oslo.config", "scapy", "thrift" ]

package { $essentials: }

package { $pipPackages:
  ensure => present,
  provider => pip,
  require => Package[$essentials],
}

package { "ryu":
  ensure => latest,
  provider => pip,
  require => Package["python-routes", "eventlet", "msgpack-python", "oslo.config"],
}

#package {"openvswitch-switch":
#  ensure  => present,
#}
#
#package {"openvswitch-controller":
#  ensure  => present,
#}
#
#package {"mininet":
#  ensure  => latest,
#  require => Package["openvswitch-switch", "openvswitch-controller"],
#}

# install swipl
package {"software-properties-common": 
  ensure => latest,
}

exec {"apt-add-repository ppa:swi-prolog/stable":
    path => "/usr/bin",
}

package {"swi-prolog":
  ensure => "installed",
  require => Exec["apt-add-repository ppa:swi-prolog/stable"],
}

package {"wireshark":
  ensure => latest,
}
