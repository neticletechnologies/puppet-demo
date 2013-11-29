# Installs Icinga packages and creates basic configuration files
class nagios::install {
	package {
		"icinga":
			ensure => installed;
		"icinga-doc":
			ensure => installed;
		"nagios-nrpe-plugin":
			ensure => installed;
		"nsca":
			ensure => installed;
	}
	file {
		"/etc/icinga":
			ensure => directory,
			notify => Service['icinga'];
		"/etc/apache2/conf.d/icinga.conf":
			ensure => absent;
		"/var/lib/icinga/rw":
			ensure => directory,
			owner  => "nagios",
			group  => "www-data",
			mode   => 0750;
	}
}
