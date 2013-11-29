class nagios::monitor::bind {
	@@nagios_service {
		"${hostname}-dns":
			use                 => "generic-service",
			check_command       => "check_dns",
			service_description => "DNS",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-dns.cfg",
			notify              => Service['icinga'];
	}
}
