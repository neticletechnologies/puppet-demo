class nagios::commands::check_smtp {
	nagios_command {
		"check_smtp_ipv4":
			target       => "/etc/icinga/objects/command-check_smtp_ipv4.cfg",
			command_line => "/usr/lib/nagios/plugins/check_smtp -H '\$HOSTNAME\$' -4"
	}
	nagios_command {
		"check_smtp_ipv6":
			target       => "/etc/icinga/objects/command-check_smtp_ipv6.cfg",
			command_line => "/usr/lib/nagios/plugins/check_smtp -H '\$HOSTNAME\$' -6"
	}
}