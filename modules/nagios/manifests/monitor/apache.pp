class nagios::monitor::apache::process {
	nagios::monitor::process {
		"apache2":
			description => "Apache";
	}
}

class nagios::monitor::apache::http {
	@@nagios_service {
		"${hostname}-http":
			use                 => "generic-service",
			check_command       => "check_http_alive",
			service_description => "HTTP Connectivity",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-http.cfg",
			notify              => Service['icinga'];
	}
}
