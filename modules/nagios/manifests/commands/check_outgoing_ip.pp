class nagios::commands::check_outgoing_ip {
	nagios_command {
		"check_outgoing_ipv4":
			target       => "/etc/icinga/objects/command-check_outgoing_ipv4.cfg",
			command_line => "/usr/lib/nagios/plugins/check_http -H ip.iptool.eu -s '\$ARG1\$' -4"
	}
}