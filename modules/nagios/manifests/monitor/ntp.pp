class nagios::monitor::ntp {
	@@nagios_service {
		"${hostname}-ntp-process":
			use                 => "generic-service",
			check_command       => "check_nrpe!check_process_running!ntpd",
			service_description => "NTPd process",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-ntp-process.cfg",
			notify              => Service['icinga'];
	}
	@@nagios_service {
		"${hostname}-ntp-time":
			use                 => "generic-service",
			check_command       => "check_nrpe_1arg!check_ntp",
			service_description => "NTP time",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-ntp-time.cfg",
			notify              => Service['icinga'];
	}
}
