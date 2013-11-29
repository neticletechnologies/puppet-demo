class nagios::commands::check_http_alive {
	nagios_command {
		"check_http_alive":
			target       => "/etc/icinga/objects/command-check_http_alive.cfg",
			command_line => "/usr/lib/nagios/plugins/check_http -H '\$HOSTADDRESS\$' -I '\$HOSTADDRESS\$' -e 'HTTP/1.1 2,HTTP/1.1 3,HTTP/1.1 4' "
	}
}