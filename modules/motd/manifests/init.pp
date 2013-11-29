class motd {
	package {
		"update-motd":
			ensure => installed;
		"update-notifier-common":
			ensure => installed;
	}
	file {
		"/etc/update-motd.d/10-ipaddr":
			ensure => file,
			mode   => 0755,
			source => "puppet:///modules/motd/10-ipaddr";
		"/etc/update-motd.d/10-help-text":
			ensure => absent;
		"/etc/update-motd.d/91-release-upgrade":
			ensure => absent;
	}
}