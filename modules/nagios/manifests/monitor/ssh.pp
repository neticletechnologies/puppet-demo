class nagios::monitor::ssh {
	nagios::monitor::process {
		"sshd":
			description => "SSHD";
	}
	@@nagios_service {
		"${hostname}-ssh":
			ensure              => absent,
			target              => "/etc/icinga/objects/${hostname}-ssh.cfg",
			notify              => Service['icinga'];
		"${hostname}-ssh-ipv4":
			use                 => "generic-service",
			check_command       => "check_ssh_ipv4",
			service_description => "SSH IPv4",
			host_name           => "${hostname}",
			target              => "/etc/icinga/objects/${hostname}-ssh-ipv4.cfg",
			notify              => Service['icinga'];
	}
#	@@nagios_service {
#		"${hostname}-ssh-ipv6":
#			use                 => "generic-service",
#			check_command       => "check_ssh_ipv6",
#			service_description => "SSH IPv6",
#			host_name           => "${hostname}",
#			target              => "/etc/icinga/objects/${hostname}-ssh-ipv6.cfg",
#			notify              => Service['icinga'];
#	}
}
