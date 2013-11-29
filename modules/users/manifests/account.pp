define users::account( $firstname,
		$lastname,
		$uid,
		$gid,
		$ingroups,
		$group    = $name,
		$password = "*",
		$email    = "",
		$shell    = "/bin/bash",
		$homeroot = "/home",
		$sshkeys  = [],
		$ensure   = "present" ) {
	case $ensure {
		present: {
			$home_owner = $name
			$home_group = $name
		}
		default: {
			$home_owner = "root"
			$home_group = "root"
		}
	}
	
	group {
		$name:
			gid    => $gid,
			name   => $name,
			ensure => $ensure;
	}
	
	user {
		$name:
			ensure     => $ensure,
			uid        => $uid,
			password   => $password,
			comment    => "${firstname} ${lastname}",
			home       => "${homeroot}/${name}",
			shell      => $shell,
			managehome => false;
	}
	
	case $ensure {
		present: {
			file {
				"${homeroot}/${name}":
					ensure  => directory,
					owner   => $home_owner,
					group   => $home_group,
					recurse => true;
				"${homeroot}/$name/.bashrc":
					ensure  => file,
					owner   => $home_owner,
					group   => $home_group,
					mode    => 0600,
					source  => "puppet:///modules/users/bashrc";
				"${homeroot}/$name/.ssh":
					ensure  => directory,
					owner   => $home_owner,
					group   => $home_group,
					mode    => 0700;
				"${homeroot}/$name/.ssh/authorized_keys":
					ensure  => file,
					owner   => $home_owner,
					group   => $home_group,
					mode    => 0600,
					content => template("users/authorized_keys.erb");
				"${homeroot}/$name/.ssh/known_hosts":
					ensure  => absent;
			}
			exec {
				"chmod 0700 ${homeroot}/${name}":
					onlyif  => "test \"$(ls -la /home |grep ${name}| awk ' { print \$1 } ')\" = \"drwx------\"";
			}
		}
		absent: {
			file {
				"${homeroot}/${name}":
					ensure  => absent,
					force   => true;
			}
		}
	}
	
	case $ensure {
		present: {
			User[$name] {
				gid     => $gid,
				groups  => $ingroups,
				require => [ Group[$name] ]
			}
		}
	}
}
