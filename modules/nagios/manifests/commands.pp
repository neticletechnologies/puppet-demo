class nagios::commands {
	file {
		"/usr/local/lib/nagios":
			ensure  => directory,
			mode    => 0755,
			recurse => true,
			source  => "puppet:///modules/nagios/plugins";
	}

	include nagios::commands::check_http_status
	include nagios::commands::check_http_alive
	include nagios::commands::check_nrpe_ipv4
	include nagios::commands::check_smtp
	include nagios::commands::check_ssh
	include nagios::commands::check_sftp
	include nagios::commands::check_tcp
	include nagios::commands::check_internet_connectivity
	include nagios::commands::check_outgoing_ip
}
