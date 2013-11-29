class nagios::commands::check_http_status {
	nagios_command {
		"check_http_status_v4":
			target       => "/etc/icinga/objects/command-check_http_status_v4.cfg",
			command_line => "/usr/lib/nagios/plugins/check_http -I '\$HOSTNAME\$' -H '\$ARG1\$' -e 'HTTP/1.1 \$ARG2\$' -4 "
	}
	nagios_command {
		"check_http_status_v6":
			target       => "/etc/icinga/objects/command-check_http_status_v6.cfg",
			command_line => "/usr/lib/nagios/plugins/check_http -I '\$HOSTNAME\$' -H '\$ARG1\$' -e 'HTTP/1.1 \$ARG2\$' -6 "
	}
}