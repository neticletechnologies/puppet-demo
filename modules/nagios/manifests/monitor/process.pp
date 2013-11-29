define nagios::monitor::process(
	$description
	) {
	@@nagios_service {
		"${hostname}-${name}-process":
			use                 => "generic-service",
			check_command       => "check_nrpe!check_process_running!${name}",
			service_description => "${description} Process",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-${name}-process.cfg",
			notify              => Service['icinga'];
	}
}
