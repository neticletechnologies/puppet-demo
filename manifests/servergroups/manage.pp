node /^([a-z]+)-([a-z]+)-manage([\d]+)\./ {
	include server::manage
}

class server::manage inherits server {
	$puppet = hiera('puppet')
	$mysqlserver   = $puppet['mysql']['server']
	$mysqluser     = $puppet['mysql']['username']
	$mysqlpassword = $puppet['mysql']['password']
	$mysqldb       = $puppet['mysql']['db']

	class {
		puppet::master:
			bindaddress => hiera('internal_ip'),
			dbserver    => $mysqlserver,
			dbuser      => $mysqluser,
			dbpassword  => $mysqlpassword,
			dbname      => $mysqldb;
	}

	$mysql = hiera('mysql')
	class {
		"mysql::server":
			root_password    => $mysql['server']['root_password'],
			override_options => $mysql['server']['override_options'],
			users            => {
				"${mysqluser}@localhost" => {
					ensure        => present,
					password_hash => mysql_password($mysqlpassword)
				}
			},
			databases => {
				"${mysqldb}" => {
					"ensure"  => "present",
					"charset" => 'utf8'
				}
			},
			grants => {
				"${mysqluser}@localhost/${mysqldb}" => {
					ensure     => present,
					options    => ['GRANT'],
					privileges => ['ALL'],
					table      => "${mysqldb}.*",
					user       => "${mysqluser}@localhost"
				}
			};
		"mysql::server::account_security":
			;
	}

	
}
