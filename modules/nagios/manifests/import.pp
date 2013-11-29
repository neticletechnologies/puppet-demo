# Imports configuration from other ohsts
class nagios::import {
	Nagios_host <<||>>
	Nagios_hostextinfo <<||>>
	Nagios_service <<||>>
	resources {
		[ "nagios_service", "nagios_servicegroup", "nagios_host" ]:
			purge => true;
	}
}
