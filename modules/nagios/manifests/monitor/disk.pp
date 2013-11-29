class nagios::monitor::disk {
	@@nagios_service {
		"${hostname}-disk":
			use                 => "generic-service",
			check_command       => "check_nrpe_1arg!check_disk",
			service_description => "Disk",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-disk.cfg",
			notify              => Service['icinga'];
	}
}
