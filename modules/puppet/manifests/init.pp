class puppet {
	include puppet::agent
}

define puppet::package (
	$filename,
	$source,
	$provider
	) {
	file {
		"/var/cache/puppet/package/${filename}":
			ensure => file,
			source => $source;
	}
	package {
		$name:
			ensure   => present,
			provider => $provider,
			source   => "/var/cache/puppet/package/${filename}",
			require  => File["/var/cache/puppet/package/${filename}"];
	}
}
