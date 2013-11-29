class nagios::monitor::proftpd {
	nagios::monitor::process {
		"proftpd":
			description => "ProFTPd";
	}
	@@nagios_service {
		"${hostname}-proftpd-sftp-ipv4":
			use                 => "generic-service",
			check_command       => "check_sftp_ipv4!2222",
			service_description => "ProFTPd SFTP IPv4",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-proftpd-sftp-ipv4.cfg",
			notify              => Service['icinga'];
		"${hostname}-proftpd-sftp-ipv6":
			use                 => "generic-service",
			check_command       => "check_sftp_ipv6!2222",
			service_description => "ProFTPd SFTP IPv6",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-proftpd-sftp-ipv6.cfg",
			notify              => Service['icinga'];
	}
}
