define nginx::vhost (
	$ensure   = 'enabled',
	$vhost    = undef,
	$aliases  = [],
	$filename = undef,
	$listen   = [
		'0.0.0.0:80'
	],
	$root                = undef,
	$ssl                 = false,
	$ssl_certificate     = '',
	$ssl_certificate_key = '',
	$location            = {},
	$error_page          = {},
	$check_status        = 200,
	$index               = 'index.html',
	$error_log           = '',
	$real_ip_header      = 'X-Forwarded-For',
	$set_real_ip_from    = [],
	$include             = [],
	$extra               = '',
	) {
	if $vhost {
		$realvhost = $vhost
	} else {
		$realvhost = $name
	}
	if $filename {
		$realfilename = $filename
	} else {
		$realfilename = $name
	}
	case $ensure {
		'enabled': {
			$available = true
			$enabled   = true
		}
		'disabled': {
			$available = true
			$enabled   = false
		}
		'absent': {
			$available = false
			$enabled   = false
		}
	}
	if $available {
		file {
			"/etc/nginx/sites-available/$realfilename":
				ensure  => file,
				notify  => Service['nginx'],
				content => template('nginx/vhost.erb');
		}
	} else {
		file {
			"/etc/nginx/sites-available/$name":
				ensure => absent,
				notify => Service['nginx'];
		}
	}
	if $enabled {
		file {
			"/etc/nginx/sites-enabled/$realfilename":
				ensure => link,
				target => "/etc/nginx/sites-available/$realfilename",
				notify => Service['nginx'];
		}
		nagios::monitor::nginx::vhost {
			$name:
				check_status => $check_status;
		}
	} else {
		file {
			"/etc/nginx/sites-enabled/$realfilename":
				ensure => absent,
				notify => Service['nginx'];
		}
	}
}
