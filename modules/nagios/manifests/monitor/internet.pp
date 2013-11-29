class nagios::monitor::internet {
	@@nagios_service {
		"${hostname}-internet-v4":
			use                 => "generic-service",
			check_command       => "check_internet_connectivity_ipv4",
			service_description => "IPv4 Internet Connectivity",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-internet-v4.cfg",
			notify              => Service['icinga'];
	}
#	@@nagios_service {
#		"${hostname}-internet-v6":
#			use                 => "generic-service",
#			check_command       => "check_internet_connectivity_ipv6",
#			service_description => "IPv6 Internet Connectivity",
#			host_name           => "${hostname}",
#			target              => "/etc/icinga/objects/${hostname}-internet-v6.cfg",
#			notify              => Service['icinga'];
#	}
}
