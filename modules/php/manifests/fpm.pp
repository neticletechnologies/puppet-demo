class php::fpm {
	include php::fpm::install
	include php::fpm::config
	include php::fpm::service

	Class['install']
	-> Class['config']
	-> Class['service']
}

class php::fpm::install {
	package {
		"php5-fpm":
			ensure => installed;
	}
}

class php::fpm::config {
	file {
		"/etc/php5/fpm/pool-available":
			ensure => directory;
		"/etc/php5/fpm/pool-enabled":
			ensure => directory;
		"/etc/php5/fpm/php-fpm.conf":
			ensure => file,
			source => "puppet:///modules/php/php-fpm.conf";
	}
}

class php::fpm::service {
	service {
		"php5-fpm":
			ensure => running;
	}
}

define php::fpm::pool (
	$listen,
	$ensure                    = 'enabled',
	$user                      = undef,
	$group                     = undef,
	$prefix                    = undef,
	$listen_backlog            = undef,
	$listen_allowed_clients    = undef,
	$listen_owner              = undef,
	$listen_group              = undef,
	$listen_mode               = undef,
	$pm                        = 'dynamic',
	$pm_max_children           = 50,
	$pm_start_servers          = 20,
	$pm_min_spare_servers      = 5,
	$pm_max_spare_servers      = 35,
	$pm_max_requests           = 500,
	$pm_status_path            = undef,
	$ping_path                 = undef,
	$ping_response             = undef,
	$access_log                = undef,
	$access_format             = undef,
	$slowlog                   = undef,
	$request_slowlog_timeout   = undef,
	$request_terminate_timeout = undef,
	$rlimit_files              = undef,
	$rlimit_core               = undef,
	$chroot                    = undef,
	$chdir                     = undef,
	$catch_workers_output      = undef,
	$security_limit_extensions = '.php',
	$env                       = {},
	$php_admin_value           = {},
	$php_admin_flag            = {},
	$php_value                 = {},
	$php_flag                  = {},
	) {
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
			"/etc/php5/fpm/pool-available/${name}.conf":
				ensure  => file,
				content => template('php/fpm/pool.erb'),
				require => Class['php::fpm::config'],
				notify  => Service['php5-fpm'];
		}
	} else {
		file {
			"/etc/php5/fpm/pool-available/${name}.conf":
				ensure  => absent,
				notify  => Service['php5-fpm'];
		}
	}
	if $createLink {
		file {
			"/etc/php5/fpm/pool-enabled/${name}.conf":
				ensure  => symlink,
				target  => "/etc/php5/fpm/pool-available/${name}.conf",
				require => Class['php::fpm::config'],
				notify  => Service['php5-fpm'];
		}
	} else {
		file {
			"/etc/php5/fpm/pool-enabled/${name}.conf":
				ensure  => absent,
				notify  => Service['php5-fpm'];
		}
	}
}
