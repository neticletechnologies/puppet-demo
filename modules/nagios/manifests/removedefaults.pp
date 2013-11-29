# Removes default Icinga configuration files
class nagios::removedefaults {
	file {
		[
			"/etc/icinga/objects/contacts_icinga.cfg",
			"/etc/icinga/objects/extinfo_icinga.cfg",
			"/etc/icinga/objects/generic-host_icinga.cfg",
			"/etc/icinga/objects/generic-service_icinga.cfg",
			"/etc/icinga/objects/hostgroups_icinga.cfg",
			"/etc/icinga/objects/localhost_icinga.cfg",
			"/etc/icinga/objects/services_icinga.cfg",
			"/etc/icinga/objects/timeperiods_icinga.cfg",
			"/etc/icinga/nagios_host.cfg",
			"/etc/icinga/nagios_hostextinfo.cfg",
			"/etc/icinga/nagios_service.cfg"
		]:
			ensure => absent;
	}
}
