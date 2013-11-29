# Create the base configuration for Icinga
class nagios::config {
	nagios::config::option {
		check_external_commands:
			value => 1;
	}
	nagios::config::cgioption {
		authorized_for_system_information:
			value => "*";
		authorized_for_configuration_information:
			value => "*";
		authorized_for_full_command_resolution:
			value => "*";
		authorized_for_system_commands:
			value => "*";
		authorized_for_all_services:
			value => "*";
		authorized_for_all_hosts:
			value => "*";
		authorized_for_all_service_commands:
			value => "*";
		authorized_for_all_host_commands:
			value => "*";
		url_html_path:
			value => "/";
	}

	include nagios::commands
}

define nagios::config::option(
	$value
	) {
	augeas {
		"nagios/$name":
			context => "/files/etc/icinga/icinga.cfg",
			onlyif  => "get /files/etc/icinga/icinga.cfg/$name != '$value'",
			changes => "set /files/etc/icinga/icinga.cfg/$name '$value'",
			notify  => Service['icinga'],
			require => Class['augeas'];
	}
}

define nagios::config::cgioption(
	$value
	) {
	augeas {
		"nagios/$name":
			context => "/files/etc/icinga/cgi.cfg",
			onlyif  => "get /files/etc/icinga/cgi.cfg/$name != '$value'",
			changes => "set /files/etc/icinga/cgi.cfg/$name '$value'",
			notify  => Service['icinga'],
			require => Class['augeas'];
	}
}

