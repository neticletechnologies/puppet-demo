define sysctl::conf(
	$value
	) {
	$key = $name

	augeas {
		"sysctl.conf/$key":
			context => "/files/etc/sysctl.conf",
			onlyif  => "get $key != '$value'",
			changes => "set ${key} ${value}",
			notify  => Exec["sysctl"];
	}
}

class sysctl {
	file {
		"/etc/sysctl.conf":
			ensure => file;
	}
	exec {
		"sysctl -p":
			alias       => 'sysctl',
			subscribe   => File [ "/etc/sysctl.conf" ],
			refreshonly => true;
	}
}
