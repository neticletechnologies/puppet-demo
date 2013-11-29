class nagios::commands::check_internet_connectivity {
	nagios_command {
		"check_internet_connectivity_ipv4":
			target       => "/etc/icinga/objects/command-check_connectivity_ipv4.cfg",
			command_line => "/usr/lib/nagios/plugins/check_ping -H 'www.google.com' -w 200,30% -c 300,50% -4"
	}
	nagios_command {
		"check_internet_connectivity_ipv6":
			target       => "/etc/icinga/objects/command-check_connecivity_ipv6.cfg",
			command_line => "/usr/lib/nagios/plugins/check_ping -H 'www.google.com' -w 200,30% -c 300,50% -6"
	}
}