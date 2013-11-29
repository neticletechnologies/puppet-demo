class nagios::monitor::puppetmaster {
	nagios::monitor::process {
		"puppet":
			description => "Puppet Master";
	}
	@@nagios_service {
		"${hostname}-puppetmaster":
			use                 => "generic-service",
			check_command       => "check_nrpe_1arg!check_puppetmaster",
			service_description => "Puppet master",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-puppetmaster.cfg",
			notify              => Service['icinga'];
	}
}
