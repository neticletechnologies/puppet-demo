filebucket {
	main:
		server => "puppet"
}

Package {
	provider => "aptitude"
}

Exec {
	path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
}

import "servergroups/*.pp"

