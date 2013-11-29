class nagios::commands::check_nrpe_ipv4 {
	nagios_command {
		"check_nrpe_ipv4":
			target       => "/etc/icinga/objects/command-check_nrpe_ipv4.cfg",
			command_line => "/usr/local/lib/nagios/check_nrpe_ipv4";
	}
}
