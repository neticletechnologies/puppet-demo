# Ensures the Icinga service is running
class nagios::service {
	service {
		"icinga":
			ensure  => running,
			require => Class['Nagios::Install'];
	}
}
