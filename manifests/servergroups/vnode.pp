node /^([a-z]+)-([a-z]+)-vnode([\d]+)\./ {
	include server::vnode
}

class server::vnode inherits server {
	include lxc
	include smart
	include ntp
	include ipmicfg
	include nagios::monitor::raid
	include nagios::monitor::ntp
	include serial

	class {
		uptrack:
			accesskey         => hiera('uptrack'),
			install_on_reboot => "yes",
			autoinstall       => "yes";
	}

	$network = hiera_hash('network')

	package {
		"bridge-utils":
			ensure => present;
	}
	network::interface::auto {
		"lxcbr0":
			;
	}
	network::interface::static {
		"lxcbr0":
			preup      => '/sbin/brctl addbr $IFACE',
			postdown   => '/sbin/brctl delbr $IFACE',
			address    => $network['lxcbr0']['address'],
			netmask    => $network['lxcbr0']['netmask'],
			broadcast  => $network['lxcbr0']['broadcast'],
			bridge_stp => "off",
			bridge_fd  => "0",
	}
	network::interface::state {
		"lxcbr0":
			ensure  => "up",
			require => Package['bridge-utils'];
	}
	
	nagios::monitor::smart {
		"sda":
			;
		"sdb":
			;
	}
	kernel::module {
		"ip_conntrack":
			ensure => present;
	}
	sysctl::conf {
		"net.ipv4.ip_forward":
			value   => 1;
		"net.netfilter.nf_conntrack_max":
			value   => 655360,
			require => Kernel::Module["ip_conntrack"];
	}

	$containers = hiera_hash('lxc')
	create_resources(lxc::container, $containers)


	$bind = hiera('bind')
	class {
		simplebind:
			records => $bind['records'],
			listen  => $bind['listen'];
		openvpn:
			listen => hiera('public_ip'),
			key    => "puppet:///files/ssl/openvpn/key.pem",
			cert   => "puppet:///files/ssl/openvpn/cert.pem";
	}
}
