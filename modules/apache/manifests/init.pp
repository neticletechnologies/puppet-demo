class apache(
	$name_virtual_host = [
		"*:80"
	],
	$listen = [
		"80"
	],
	$listenSSL = [
	],
	) {
	include apache::install
	include apache::config
	include apache::service
	include apache::monitor

	Class['install']
	-> Class['config']
	-> Class['service']
	-> Class['monitor']
}

class apache::install {
	package {
		"apache2":
			ensure => installed;
		"apache2-mpm-prefork":
			ensure => installed;
	}
}

class apache::config {
	file {
		"/etc/apache2/sites-enabled/000-default":
			ensure => absent;
		"/etc/apache2/ports.conf":
			ensure  => file,
			content => template("apache/ports.conf.erb");
	}
}

class apache::service {
	service {
		"apache2":
			ensure => running;
	}
}

class apache::monitor {
	include nagios::monitor::apache::process
	include nagios::monitor::apache::http
}

define apache::module(
	$ensure  = 'enabled',
	$conf    = false,
	$package = undef,
	) {
	case $ensure {
		'enabled': {
			file {
				"/etc/apache2/mods-enabled/${name}.load":
					ensure => symlink,
					target => "/etc/apache2/mods-available/${name}.load",
					notify => Service['apache2'];
			}
			if $conf {
				file {
					"/etc/apache2/mods-enabled/${name}.conf":
						ensure => symlink,
						target => "/etc/apache2/mods-available/${name}.conf",
						notify => Service['apache2'];
				}
			} else {
				file {
					"/etc/apache2/mods-enabled/${name}.conf":
						ensure => absent,
						notify => Service['apache2'];
				}
			}
			if ($package) {
				package {
					$package:
						ensure => present,
						notify => Service['apache2'],
						before => [
							File["/etc/apache2/mods-enabled/${name}.load"],
							File["/etc/apache2/mods-enabled/${name}.conf"]
						];
				}
			}
		}
		'disabled': {
			file {
				"/etc/apache2/mods-enabled/${name}.load":
					ensure => absent,
					notify => Service['apache2'];
				"/etc/apache2/mods-enabled/${name}.conf":
					ensure => absent,
					notify => Service['apache2'];
			}
			if ($package) {
				package {
					$package:
						ensure => present,
						notify => Service['apache2'];
				}
			}
		}
		'absent': {
			file {
				"/etc/apache2/mods-enabled/${name}.load":
					ensure => absent,
					notify => Service['apache2'];
				"/etc/apache2/mods-enabled/${name}.conf":
					ensure => absent,
					notify => Service['apache2'];
			}
			if ($package) {
				package {
					$package:
						ensure => absent,
						notify => Service['apache2'];
				}
			}
		}
	}
}

define apache::vhost(
	$ensure        = 'enabled',
	$server_name   = '',
	$server_admin  = '',
	$vhostspec     = '*:80',
	$server_alias  = [],
	$document_root = '',
	$alias         = {},
	$script_alias  = {},
	$error_log     = '',
	$log_level     = '',
	$location      = {},
	$directory     = {
			"${document_root}" => {
				'AllowOverride' => 'All',
				'Order'         => 'Allow,Deny',
				'Allow'         => 'from all',
			},
		},
	$extra         = {},
	) {
	if $ServerName != '' {
		$myName = $ServerName
	} else {
		$myName = $name
	}
	case $ensure {
		'enabled': {
			$createFile = true
			$createLink = true
		}
		'disabled': {
			$createFile = true
			$createLink = false
		}
		'absent': {
			$createFile = false
			$createLink = false
		}
	}
	if $createFile {
		file {
			"/etc/apache2/sites-available/${name}":
				ensure  => file,
				content => template('apache/virtualhost.erb'),
				require => Class['apache::install'],
				notify  => Service['apache2'];
		}
	} else {
		file {
			"/etc/apache2/sites-available/${name}":
				ensure  => absent,
				notify  => Service['apache2'];
		}
	}
	if $createLink {
		file {
			"/etc/apache2/sites-enabled/${name}":
				ensure  => symlink,
				target  => "/etc/apache2/sites-available/${name}",
				require => Class['apache::install'],
				notify  => Service['apache2'];
		}
	} else {
		file {
			"/etc/apache2/sites-enabled/${name}":
				ensure  => absent,
				notify  => Service['apache2'];
		}
	}
}
