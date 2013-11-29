class nagios::twilio (
	$from,
	$userid,
	$authtoken
	) {
	package {
		"libjson-perl":
			ensure  => installed;
		"libwww-perl":
			ensure  => installed;
	}
	file {
		"/usr/local/bin/twilio-sms":
			ensure => file,
			mode   => 0755,
			source => "puppet:///modules/nagios/bin/twilio-sms";
		"/etc/icinga/twilio-sms.conf":
			ensure  => file,
			mode    => 0644,
			content => template("nagios/twilio-sms.conf.erb");
	}
	nagios_command {
		"notify-host-by-sms":
			target       => "/etc/icinga/objects/command-notify_host_by_sms.cfg",
			command_line => '/usr/bin/printf "%b" "$NOTIFICATIONTYPE$ $HOSTNAME$ $HOSTSTATE$\n$HOSTOUTPUT$" | /usr/local/bin/twilio-sms -- $CONTACTPAGER$';
		"notify-service-by-sms":
			target       => "/etc/icinga/objects/command-notify_service_by_sms.cfg",
			command_line => '/usr/bin/printf "%b" "$NOTIFICATIONTYPE$ $HOSTNAME$ $SERVICEDESC$ $SERVICESTATE$\n$SERVICEOUTPUT$" | /usr/local/bin/twilio-sms -- $CONTACTPAGER$';
	}

}
