class nagios::monitor::outgoing (
	$ipaddress
	) {
	@@nagios_service {
		"${hostname}-outgoing-ipv4":
			use                 => "generic-service",
			check_command       => "check_outgoing_ipv4",
			service_description => "Outgoing IPv4 Address",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-outgoing-v4.cfg",
			notify              => Service['icinga'];
	}
}
