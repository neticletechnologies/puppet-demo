class nagios::commands::check_tcp {
	nagios_command {
		"check_tcp_ipv4":
			target       => "/etc/icinga/objects/command-check_tcp_ipv4.cfg",
			command_line => "/usr/lib/nagios/plugins/check_tcp -H '\$HOSTNAME\$' -p '\$ARG1\$' -4"
	}
	nagios_command {
		"check_tcp_ipv6":
			target       => "/etc/icinga/objects/command-check_tcp_ipv6.cfg",
			command_line => "/usr/lib/nagios/plugins/check_tcp -H '\$HOSTNAME\$' -p '\$ARG1\$' -6"
	}
}