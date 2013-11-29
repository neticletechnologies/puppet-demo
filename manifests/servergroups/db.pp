node /^([a-z]+)-([a-z]+)-db([\d]+)\./ {
	include server::db
}

class server::db inherits server {
	$mysql = hiera('mysql')
	class {
		"mysql::server":
			root_password    => $mysql['server']['root_password'],
			override_options => $mysql['server']['override_options'];
		"mysql::server::account_security":
			;
	}
}
