define nagios::monitor::smart {
	@@nagios_service {
		"${hostname}-smart-${name}":
			use                 => "generic-service",
			check_command       => "check_nrpe!check_smart!${name}",
			service_description => "S.M.A.R.T ${name}",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-smart-${name}.cfg",
			notify              => Service['icinga'];
	}
}
