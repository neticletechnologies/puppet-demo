class nagios::commands::check_sftp {
	nagios_command {
		"check_sftp_ipv4":
			target       => "/etc/icinga/objects/command-check_sftp_ipv4.cfg",
			command_line => "/usr/lib/nagios/plugins/check_ssh -H '\$HOSTNAME\$' -p '\$ARG1\$' -4"
	}
	nagios_command {
		"check_sftp_ipv6":
			target       => "/etc/icinga/objects/command-check_sftp_ipv6.cfg",
			command_line => "/usr/lib/nagios/plugins/check_ssh -H '\$HOSTNAME\$' -p '\$ARG1\$' -6"
	}
}