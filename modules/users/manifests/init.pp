class users {
	user {
		"root":
			password   => '*';
	}
	file {
		"/etc/bash.bashrc":
			ensure  => file,
			owner   => "root",
			group   => "root",
			mode    => 0644,
			source  => "puppet:///modules/users/bashrc";
		"/home":
			ensure  => directory,
			owner   => "root",
			group   => "root",
			mode    => 0755;
		"/root":
			ensure  => directory,
			owner   => "root",
			group   => "root",
			mode    => 0700;
		"/root/.ssh/authorized_keys":
			ensure  => absent,
			force   => true;
		"/root/.bashrc":
			ensure  => file,
			owner   => "root",
			group   => "root",
			mode    => 0600,
			source  => "puppet:///modules/users/bashrc";
	}

	file {
		"/etc/sudoers":
			ensure => present,
			owner  => "root",
			group  => "root",
			mode   => 0440,
			source => "puppet:///modules/users/sudoers";
	}
}
