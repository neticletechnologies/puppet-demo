class openvpn (
	$listen,
	$key,
	$cert
	) {
	include openvpn::install
	class {
		openvpn::config:
			listen => $listen,
			key    => $key,
			cert   => $cert;
	}
	include openvpn::service

	Class['install']
	-> Class['config']
	-> Class['service']
}

class openvpn::install {
	package {
		"openvpn":
			ensure => latest;
	}
}

class openvpn::config (
	$listen,
	$key,
	$cert
	) {
	file {
		"/etc/openvpn/server.conf":
			ensure => file,
			content => template("openvpn/openvpn.conf.erb"),
			notify => Class['openvpn::service'];
		"/etc/openvpn/server.crt":
			ensure => file,
			source => $cert,
			mode   => 0640,
			notify => Class['openvpn::service'];
		"/etc/openvpn/server.key":
			ensure => file,
			source => $key,
			mode   => 0640,
			notify => Class['openvpn::service'];
	}
	exec {
		"openssl dhparam -out /etc/openvpn/dh.pem 10240":
			creates => '/etc/openvpn/dh.pem';
	}
}

class openvpn::service {
	service {
		"openvpn":
			ensure => running;
	}
}
