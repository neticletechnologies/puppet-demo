class ntp {
	include ntp::install
}

class ntp::install {
	package {
		"ntp":
			ensure => installed;
	}
}

class ntp::service {
	service {
		"ntpd":
			ensure => running;
	}
}