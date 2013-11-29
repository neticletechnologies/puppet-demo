# Creates the base config files for configuring the kernel
class kernel {
	file {
		"/etc/modules":
			ensure => file;
	}
}

# Adds a kernel module to /etc/modules and loads the module via modprobe.
#
# @param string $ensure
define kernel::module(
	$ensure = "present"
	) {
	case $ensure {
		'present': {
			$condition = "match $name != ''"
			# Create an empty node at $name in /etc/modules
			$command   = "clear ${name}"
			exec {
				"modprobe $name":
					alias       => "modprobe ${name}",
					subscribe   => Augeas["modules/$name"],
					refreshonly => true;
			}
		}
		'absent': {
			$condition = "match $name != ''"
			$command   = "rm ${name}"
			exec {
				"modprobe -r $name":
					alias       => "modprobe ${name}",
					subscribe   => Augeas["modules/$name"],
					refreshonly => true;
			}
		}
	}
	augeas {
		"modules/$name":
			context => "/files/etc/modules",
			onlyif  => $condition,
			changes => $command,
			notify  => Exec["modprobe ${name}"];
	}
}
