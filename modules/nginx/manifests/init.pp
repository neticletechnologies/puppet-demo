class nginx(
	$proxyListen    = [ '0.0.0.0:80' ],
	$proxySSLListen    = [ '0.0.0.0:443' ],
	$proxyErrorPage = {},
	$importTag = '',
	$importSSLTag = '',
	) {
	include nginx::install
	include nginx::config
	include nginx::import
	include nginx::service
	include nginx::monitor

	Class['install']
	-> Class['config']
	-> Class['import']
	-> Class['service']
	-> Class['monitor']

}

class nginx::install {
	package {
		"nginx-extras":
			ensure => installed;
	}
	file {
		"/var/www/":
			ensure => directory;
	}
}

class nginx::config {
	nginx::vhost {
		'default':
			ensure => disabled;
	}
}

class nginx::import {
	Nginx::Vhost::Proxy<<| tag == $importTag |>> {
		listen     => $proxyListen,
		error_page => $proxyErrorPage,
	}
	Nginx::Vhost::Fcgi<<| tag == $importTag |>> {
		listen     => $proxyListen,
		error_page => $proxyErrorPage,
	}
	Nginx::Vhost::Redirect<<| tag == $importTag |>> {
		listen     => $proxyListen,
		error_page => $proxyErrorPage,
	}
	Nginx::Vhost::Proxy<<| tag == $importSSLTag |>> {
		listen     => $proxySSLListen,
		error_page => $proxyErrorPage,
	}
	Nginx::Vhost::Fcgi<<| tag == $importSSLTag |>> {
		listen     => $proxySSLListen,
		error_page => $proxyErrorPage,
	}
	Nginx::Vhost::Redirect<<| tag == $importSSLTag |>> {
		listen     => $proxySSLListen,
		error_page => $proxyErrorPage,
	}
}

class nginx::service {
	service {
		"nginx":
			ensure => running;
	}
}

class nginx::monitor {
	include nagios::monitor::nginx::process
	include nagios::monitor::nginx::http
}
