# These are the packages we deem useful on a production system. There are also a few that are unneccessary or
# harmful, so we remove them.
class basepackages {
	# Aptitude is our provider for packages
	package {
		"aptitude":
			ensure   => present,
			provider => "apt";
		unattended-upgrades:
			ensure   => present;
	}
	file {
		"/etc/apt/apt.conf.d/20auto-upgrades":
			ensure  => file,
			source  => "puppet:///modules/basepackages/20auto-upgrades",
			require => Package["unattended-upgrades"];
		"/etc/apt/apt.conf.d/50unattended-upgrades":
			ensure  => file,
			source  => "puppet:///modules/basepackages/50unattended-upgrades",
			require => Package["unattended-upgrades"];
	}
	# Accessing remote addresses, downloading stuff, etc.
	package {
		"curl":
			ensure   => present;
		"links":
			ensure   => present;
		"lynx":
			ensure   => present;
		"wget":
			ensure   => present;
	}
	# Network/debugging utilities
	package {
		"dnsutils":
			ensure   => present;
		"mtr":
			ensure   => present;
		"strace":
			ensure   => present;
		"htop":
			ensure   => present;
		"openssl":
			ensure   => present;
		"tcpdump":
			ensure   => present;
		"tcpflow":
			ensure   => present;
		"telnet":
			ensure   => present;
		"dsniff":
			ensure   => present;
		"traceroute":
			ensure   => present;
	}
	# Man pages
	package {
		"manpages":
			ensure   => present;
		"man-db":
			ensure   => present;
	}
	# Misc
	package {
		"mc":
			ensure   => present;
		"nano":
			ensure   => present;
		"rsync":
			ensure   => present;
		"git":
			ensure   => present;
		"unzip":
			ensure   => present;
		"sudo":
			ensure   => present;
		"bash-completion":
			ensure   => present;
	}
	file {
		"/etc/mc/mc.ini":
			ensure   => file,
			source   => "puppet:///modules/basepackages/mc.ini";
		"/var/log/upstart":
			ensure => directory;
	}
	# Stuff we don't want.
	package {
		# We don't use DHCP
		"isc-dhcp-client":
			ensure   => absent;
		# Popularity contest breaks our crons and sends mail every night.
		"popularity-contest":
			ensure   => absent;
		# We don't use the Ubuntu update manager, just the common scripts.
		"update-manager-core":
			ensure   => absent;
		# We definitely don't use Landscape
		"landscape-common":
			ensure   => absent;
	}
}

define deb (
	$ensure = 'present',
	$source
	) {
	file {
		"/var/tmp/${name}.deb":
			ensure => file,
			source => $source;
	}
	package {
		$name:
			ensure   => $ensure,
			provider => dpkg,
			source   => "/var/tmp/$name.deb";
	}
}


