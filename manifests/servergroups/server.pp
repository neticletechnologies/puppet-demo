node default {
	include server
}

class server {
	include common
	include stdlib
	include basepackages

	include users
	include ssh
	include sysctl
	include puppet::agent
	include augeas
	include motd
	include network

	$hostname    = hiera('hostname')
	$domain      = hiera('domain')
	$fqdn        = "${hostname}.${domain}"
	$public_ip   = hiera('public_ip')
	$internal_ip = hiera('internal_ip')

	network::interface::auto {
		"lo":
			;
	}
	network::interface::loopback {
		"lo":
			;
	}
	network::interface::loopback6 {
		"lo":
			;
	}

	$network = hiera_hash('network')

	network::interface::auto {
		"eth0":
			;
	}
	network::interface::static {
		"eth0":
			address   => $network['eth0']['address'],
			netmask   => $network['eth0']['netmask'],
			broadcast => $network['eth0']['broadcast'],
			gateway   => $network['eth0']['gateway'];
	}
	network::interface::state {
		"eth0":
			ensure => "up";
	}

	
	sysctl::conf {
		"net.ipv4.tcp_syncookies":
			value => 1;
		"net.ipv4.conf.all.accept_redirects":
			value => 0;
		"net.ipv6.conf.all.accept_redirects":
			value => 0;
		"net.ipv4.conf.all.send_redirects":
			value => 0;
		"net.ipv4.conf.all.accept_source_route":
			value => 0;
		"net.ipv6.conf.all.accept_source_route":
			value => 0;
		"net.ipv4.icmp_echo_ignore_broadcasts":
			value => 1;
	}
	resolv {
		$fqdn:
			nameservers => hiera('nameservers');
	}
	hosts {
		$fqdn:
			ipaddr  => "${internal_ip}";
	}

	$users = hiera_hash('users')
	create_resources(users::account, $users)

	nagios::host {
		$fqdn:
			nrpeListen => "${internal_ip}";
	}
}
