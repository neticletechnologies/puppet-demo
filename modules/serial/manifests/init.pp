class serial {
	file {
		"/etc/default/grub":
			ensure => file,
			source => "puppet:///modules/serial/grub",
			notify => Exec[ "update-grub" ];
		"/etc/init/ttyS0.conf":
			ensure => file,
			source => "puppet:///modules/serial/ttyS0.conf",
			notify => Service['ttyS0'];
	}

	exec {
		"update-grub":
			command     => "/usr/sbin/update-grub",
			refreshonly => true;
	}

	service {
		"ttyS0":
			ensure => running,
			provider => upstart,
			require => File['/etc/init/ttyS0.conf'];
	}
}