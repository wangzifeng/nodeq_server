Exec {
	path => [
	'/usr/local/bin',
	'/opt/local/bin',
	'/usr/bin', 
	'/usr/sbin', 
	'/bin',
	'/sbin'],
	logoutput => true,
}

class install {

	#exec {'apt-get update -y':}

	#exec {'apt-get upgrade -y':}

	package {'curl':
		ensure => present,
	}

	package {'git-core':
		ensure => present,
	}

	package { 'build-essential':
		ensure => present,
	}

	package {'git':
		ensure => present,
	}

	package {'nginx':
		ensure => present,
	}

	package { 'mysql-server':
		ensure => present,
	}

	# Fix rails javascript runtime issue
	package {'nodejs':
		ensure => present;
	}

}

class mysql {
	service { 'mysql':
		ensure => running,
		enable => true,
	}
}


class nginx {
	service { 'nginx':
		ensure => running,
		enable => true,
		#subscribe => File['/etc/nginx/nginx.conf'],
	}

	#Need to update with mountable path

	file {'/etc/nginx/nginx.conf':
		ensure => present,
		mode => 644,
		notify => Service['nginx'],
		source => '/OMG/modules/modules/nginx/nginx.conf',
	}

	#Need to update with mountable path

	file {'/etc/nginx/sites-enabled/default':
		ensure => present,
		mode => 644,
		notify => Service['nginx'],	
		target => '/OMG/modules/modules/nginx/production.conf',
	}
}

class crew {	
	user { 'mysql' :
		ensure => present,
		managehome => false,
		gid => '8888',
		shell => '/sbin/nologin',
	}

	group {	'mysql':
		ensure => present,
		gid => '8888',
	}

	user { 'nginx' :
		ensure => present,
		managehome => false,
		gid => '7777',
		shell => '/sbin/nologin',
	}

	group {	'nginx':
		ensure => present,
		gid => '7777',
	}

}

include install
include nginx
include mysql