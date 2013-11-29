class nagios::monitor::syslog {
	@@nagios_service {
		"${hostname}-syslog":
			use                 => "generic-service",
			check_command       => "check_tcp_ipv4!514",
			service_description => "Syslog IPv4",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-syslog.cfg",
			notify              => Service['icinga'];
	}
}
