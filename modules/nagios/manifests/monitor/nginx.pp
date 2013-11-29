class nagios::monitor::nginx::process {
	nagios::monitor::process {
		"nginx":
			description => "nginx";
	}
}

class nagios::monitor::nginx::http {
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

define nagios::monitor::nginx::vhost(
	$check_status
	) {
	@@nagios_service {
		"${hostname}-http-${name}-v4":
			use                 => "generic-service",
			check_command       => "check_http_status_v4!${name}!${check_status}",
			service_description => "HTTP ${name} IPv4",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-http-v4.cfg",
			notify              => Service['icinga'];
	}
	@@nagios_service {
		"${hostname}-http-${name}-v6":
			use                 => "generic-service",
			check_command       => "check_http_status_v6!${name}!${check_status}",
			service_description => "HTTP ${name} IPv6",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-http-v6.cfg",
			notify              => Service['icinga'];
	}
}
