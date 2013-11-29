class simplebind (
	$records = {},
	$listen  = "0.0.0.0"
) {
	class {
		install:
			;
		config:
			records => $records,
			listen  => $listen;
		service:
			;
	}

	Class ['install']
	-> Class ['config']
	-> Class ['service']
}

class simplebind::install {
	package {
		"bind9":
			ensure => latest;
	}
}

class simplebind::config (
	$records = {},
	$listen = "0.0.0.0"
	) {
	file {
		"/etc/bind/named.conf.default-zones":
			ensure => file,
			notify => Class['service'],
			source => "puppet:///modules/simplebind/named.conf.default-zones";
		"/etc/bind/named.conf.local":
			ensure => file,
			notify => Class['service'],
			source => "puppet:///modules/simplebind/named.conf.local";
		"/etc/bind/named.conf.options":
			ensure => file,
			notify => Class['service'],
			content => template('simplebind/named.conf.options.erb');
		"/etc/bind/db.102.10.in-addr.arpa":
			ensure => file,
			notify => Class['service'],
			content => template('simplebind/db.102.10.in-addr.arpa.erb');
	}
}

class simplebind::service {
	service {
		bind9:
			ensure => running;
	}
}
