# Create a host configuration in Icinga.
define nagios::host(
	$nrpeListen
	) {
	$os = downcase($operatingsystem)
	@@nagios_host {
		$hostname:
			ensure          => present,
			alias           => $fqdn,
			address         => $nrpeListen,
			use             => "generic-host",
			target          => "/etc/icinga/objects/${hostname}-host.cfg",
			notify          => Service['icinga'];
	}
	@@nagios_hostextinfo {
		$hostname:
			ensure          => present,
			icon_image_alt  => $operatingsystem,
			icon_image      => "base/${os}.png",
			statusmap_image => "base/${os}.gd2",
			target          => "/etc/icinga/objects/${hostname}-hostextinfo.cfg",
			notify          => Service['icinga'];
	}
	
	group {
		"nagios":
			gid => 300;
	}
	user {
		"nagios":
			uid    => 300,
			gid    => 300,
			groups => [ 'disk' ],
			notify => Service['nagios-nrpe-server'];
	}
	
	file {
		"/usr/local/lib/nrpe":
			ensure  => directory,
			mode    => 0755,
			recurse => true,
			source  => "puppet:///modules/nagios/nrpe/";
	}
	package {
		"nagios-nrpe-server":
			ensure => present;
		"nsca-client":
			ensure => present;
		"nagios-plugins-standard":
			ensure => present;
		"nagios-plugins-extra":
			ensure => present;
	}
	file {
		"/etc/nagios/nrpe.cfg":
			alias   => "nrpe.cfg",
			ensure  => file,
			content => template("nagios/nrpe.cfg.erb"),
			require => Package['nagios-nrpe-server'],
			notify  => Service['nagios-nrpe-server'];
		"/etc/nagios/nrpe.d":
			ensure  => directory,
			recurse => true,
			mode    => 0755,
			source  => "puppet:///modules/nagios/nrpe.d/",
			require => Package['nagios-nrpe-server'],
			notify  => Service['nagios-nrpe-server'];
	}
	service {
		"nagios-nrpe-server":
			ensure  => running,
			require => [
				File['nrpe.cfg']
			];
	}
	include nagios::monitor::disk
	include nagios::monitor::internet
}
