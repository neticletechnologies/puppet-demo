class uptrack (
	$accesskey,
	$https_proxy = '',
	$gconf_proxy_lookup = 'no',
	$ssl_ca_cert_file = '',
	$ssl_ca_cert_dir = '',
	$update_repo_url = '',
	$install_on_reboot = 'yes',
	$upgrade_on_reboot = '',
	$autoinstall = 'no'
	) {
	include uptrack::repo
	include uptrack::install
	include uptrack::configure
	
	Class['repo']
	-> Class['install']
	-> Class['configure']
}

class uptrack::repo {
	apt::source {
		"ksplice":
			location    => "http://www.ksplice.com/apt",
			release     => "precise",
			repos       => "ksplice",
			key         => "B6D4038E",
			key_server  => "keyserver.ubuntu.com",
			include_src => true;
	}
	apt::key {
		"ksplice":
			key         => "B6D4038E",
			key_server  => "keyserver.ubuntu.com";
	}
}

class uptrack::install {
	package {
		"uptrack":
			ensure => installed;
	}
}

class uptrack::configure {
	file {
		"/etc/uptrack/uptrack.conf":
			ensure  => file,
			content => template('uptrack/uptrack.conf.erb');
	}
}
