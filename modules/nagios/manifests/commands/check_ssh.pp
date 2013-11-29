class nagios::commands::check_ssh {
	nagios_command {
		"check_ssh_ipv4":
			target       => "/etc/icinga/objects/command-check_ssh_ipv4.cfg",
			command_line => "/usr/lib/nagios/plugins/check_ssh -H '\$HOSTNAME\$' -4"
	}
	nagios_command {
		"check_ssh_ipv6":
			target       => "/etc/icinga/objects/command-check_ssh_ipv6.cfg",
			command_line => "/usr/lib/nagios/plugins/check_ssh -H '\$HOSTNAME\$' -6"
	}
}