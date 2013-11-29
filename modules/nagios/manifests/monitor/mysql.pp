class nagios::monitor::mysql(
	$mysqluser     = 'monitor',
	$mysqlpassword = ''
	) {
	nagios::monitor::process {
		"mysqld":
			description => "MySQL Server";
	}
	@@nagios_service {
		"${hostname}-mysql":
			ensure              => present,
			use                 => "generic-service",
			service_description => "MySQL Connectivity",
			host_name           => "${hostname}",
			check_command       => "check_mysql_cmdlinecred!${mysqluser}!${mysqlpassword}",
			target              => "/etc/icinga/objects/${hostname}-mysql.cfg",
			notify              => Service['icinga'];
	}
}

define nagios::monitor::mysql::database(
	$mysqluser     = 'monitor',
	$mysqlpassword = ''
	) {
	@@nagios_service {
		"${hostname}-mysql-${name}":
			ensure              => present,
			use                 => "generic-service",
			service_description => "MySQL DB ${name}",
			host_name           => "${hostname}",
			check_command       => "check_mysql_database!${mysqluser}!${mysqlpassword}!${name}",
			target              => "/etc/icinga/objects/${hostname}-mysql-${name}.cfg",
			notify              => Service['icinga'];
	}
}
