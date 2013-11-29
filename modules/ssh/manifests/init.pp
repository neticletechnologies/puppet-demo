class ssh (
	$customconfig = false
	) {
	$partial_hostname = regsubst($fqdn, "\\.${domain}\$", '')
	if $partial_hostname == $hostname {
		$host_aliases = [ $ipaddress, $ipaddress6, $hostname ]
	} else {
		$host_aliases = [ $ipaddress, $ipaddress6, $hostname, $partial_hostname ]
	}

	@@sshkey {
		$fqdn:
			ensure       => present,
			host_aliases => $host_aliases,
			type         => 'rsa',
			key          => $sshrsakey,
			tag          => 'sshkey'
	}

	Sshkey <<| tag == 'sshkey' |>>

	include ssh::client
	include ssh::server
}

class ssh::client {
	package {
		"openssh-client":
			ensure => present;
	}
	file {
		"/etc/ssh/ssh_known_hosts":
			mode => 0644;
		"/etc/ssh/ssh_config":
			ensure => file,
			source => "puppet:///modules/ssh/ssh_config",
			require => Package["openssh-client"];
		"/etc/bash_completion.d/ssh":
			ensure  => file,
			source  => "puppet:///modules/ssh/ssh.completion",
			require => Package["openssh-client"];
	}
}

class ssh::server {
	package {
		"openssh-server":
			ensure => present;
	}
	file {
		"/etc/ssh/sshd_config":
			ensure  => file,
			source  => "puppet:///modules/ssh/sshd_config",
			require => Package["openssh-server"],
			notify  => Service["ssh"];
	    
	}
	service {
		"ssh":
			ensure  => running,
			enable  => true;
	}
	include nagios::monitor::ssh
}
