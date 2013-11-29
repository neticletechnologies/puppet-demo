node /^([a-z]+)-([a-z]+)-monitor([\d]+)\./ {
	include server::monitor
}

class server::monitor inherits server {
	include nagios
	include apache
	include collectd
	
	apache::module {
		"negotiation":
			ensure => 'disabled';
		"auth_pam":
			ensure  => 'absent',
			package => 'libapache2-mod-auth-pam';
		"authnz_external":
			ensure  => 'enabled',
			package => 'libapache2-mod-authnz-external';
		"php5":
			ensure  => 'enabled',
			conf    => 'true',
			package => 'libapache2-mod-php5';
	}
	package {
		"pwauth":
			ensure => present;
	}
	user {
		"www-data":
			groups => [ "nagios" ];
	}
	apache::vhost {
		"${fqdn}":
			document_root => '/usr/share/icinga/htdocs',
			alias => {
				"/stylesheets"        => "/etc/icinga/stylesheets",
				"/icinga/stylesheets" => "/etc/icinga/stylesheets",
			},
			script_alias => {
				"/cgi-bin/icinga" => "/usr/lib/cgi-bin/icinga",
				"/icinga/cgi-bin" => "/usr/lib/cgi-bin/icinga"
			},
			directory => {
				"/usr/share/icinga/htdocs" => {
					"AllowOverride"          => "All",
					"Order"                  => "Allow,deny",
					"Allow"                  => "from all",
					"AuthType"               => "Basic",
					"AuthName"               => "OpsGears",
					"AuthBasicProvider"      => "external",
					"AuthExternal"           => "pwauth",
					"Require"                => "valid-user",
				},
				"/usr/lib/cgi-bin/icinga" => {
					"AllowOverride"          => "All",
					"Order"                  => "Allow,deny",
					"Allow"                  => "from all",
					"AuthType"               => "Basic",
					"AuthName"               => "OpsGears",
					"AuthBasicProvider"      => "external",
					"AuthExternal"           => "pwauth",
					"Require"                => "valid-user",
				},
			},
			extra => {
				"AddExternalAuth"        => "pwauth /usr/sbin/pwauth",
				"SetExternalAuthMethod"  => "pwauth pipe",
			},
			require => Package['pwauth'],
	}

	$twilio = hiera('twilio')
	class {
		nagios::twilio:
			from      => $twilio['from'],
			userid    => $twilio['userid'],
			authtoken => $twilio['authtoken'];
	}

	$contacts = hiera_hash('nagios')
	create_resources(nagios_contact, $contacts)
}
