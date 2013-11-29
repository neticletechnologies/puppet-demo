# Creates the hosts entries for the server
#
# @param string $ipaddr    the IPv4 address to use
# @param string $ipaddr6   the IPv6 address to use
define hosts(
	$ipaddr,
	$ipaddr6 = undef
	) {
	file {
		"/etc/hosts":
			ensure  => file,
			mode    => 0644,
			content => template("hosts/hosts.erb");
	}
}
