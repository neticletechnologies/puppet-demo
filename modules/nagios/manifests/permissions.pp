# Create the base configuration for Icinga
class nagios::permissions {
	file {
		"/etc/icinga/objects":
			ensure  => directory,
			recurse => true,
			owner   => nagios,
			group   => nagios,
			notify  => Service['icinga'];
	}
}
