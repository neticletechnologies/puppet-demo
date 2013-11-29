class nagios::monitor::raid {
	@@nagios_service {
		"${hostname}-raid":
			use                 => "generic-service",
			check_command       => "check_nrpe_1arg!check_raid",
			service_description => "RAID",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-raid.cfg",
			notify              => Service['icinga'];
	}
}
