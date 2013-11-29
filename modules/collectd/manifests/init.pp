class collectd {
	class {
		collectd::install:
			;
		collectd::config:
			;
		collectd::service:
			;
	}
}

class collectd::install {
	package {
		"collectd":
			ensure =>present;
	}
}

class collectd::config {
}

class collectd::service {
}
