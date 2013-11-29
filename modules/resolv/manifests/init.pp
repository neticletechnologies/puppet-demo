define resolv (
	$nameservers = []
	) {
	package {
		"resolvconf":
			ensure => absent;
	}
	file {
		"/etc/resolv.conf":
			ensure  => file,
			mode    => 0644,
			content => template("resolv/resolv.conf.erb");
	}
}
