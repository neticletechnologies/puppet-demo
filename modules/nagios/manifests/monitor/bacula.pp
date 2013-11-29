class nagios::monitor::bacula {
	@@nagios_service {
		"${hostname}-bacula-director-process":
			use                 => "generic-service",
			check_command       => "check_nrpe!check_process_running!bacula-dir",
			service_description => "Bacula Director Process",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-bacula-director-process.cfg",
			notify              => Service['icinga'];
	}
	@@nagios_service {
		"${hostname}-bacula-jobs":
			use                 => "generic-service",
			check_command       => "check_nrpe_1arg!check_bacula_jobs",
			service_description => "Bacula Jobs",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-bacula-jobs.cfg",
			notify              => Service['icinga'];
	}
}
