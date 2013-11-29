class smart {
	include smart::install
}

class smart::install {
	package {
		"smartmontools":
			ensure => latest;
	}
}
