class ipmicfg {
	file {
		"/var/cache/apt/archives/ipmicfg_integration-1.02.deb":
			ensure => file,
			source => "puppet:///modules/ipmicfg/ipmicfg_integration-1.02.deb";
	}
	package {
		"ipmicfg_integration":
			ensure   => present,
			provider => dpkg,
			source   => "/var/cache/apt/archives/ipmicfg_integration-1.02.deb",
			require  => File['/var/cache/apt/archives/ipmicfg_integration-1.02.deb'];
	}
}
