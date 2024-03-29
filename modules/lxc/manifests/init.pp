# LXC management class for Puppet
#
# @license http://opensource.org/licenses/BSD-3-Clause
# @package lxc
# @author  Janos Pasztor <business@janoszen.com>

# LXC metaclass
class lxc {
	include lxc::host
}

# Takes care of everything LXC host-related.
class lxc::host {
	include lxc::install
	include lxc::config
	include lxc::service

	Class ['install']
	-> Class['config']
	-> Class['service']
}

# Ensures, that the LXC host packages are installed
class lxc::install {
	package {
		"lxc":
			ensure => latest;
	}
}

# Configures LXC
class lxc::config {
	file {
		"/usr/lib/lxc/templates/lxc-*****":
			ensure => file,
			mode   => 0755,
			source => "puppet:///modules/lxc/lxc-*****";
		"/etc/default/lxc":
			ensure => file,
			source => "puppet:///modules/lxc/lxc.default",
			notify => Class['lxc::service'];
	}
}

# Ensures the LXC service is running
class lxc::service {
	service {
		"lxc":
			ensure => running;
	}
}

# Manages an LXC container
# @param running|stopped|absent $ensure
# @param string                 $template  LXC template to use
# @param string                 $vgname    volume group to use
# @param string                 $host      host to run the container on (not used a.t.m.)
# @param bool                   $autostart automatically start container at boot
# @param int                    $lvsize    logical volume size in GB
define lxc::container(
	$ensure     = running,
	$template   = undef,
	$vgname     = undef,
	$host       = undef,
	$autostart  = true,
	$lvsize     = 5,
	$filesystem = 'ext4',
	$opts       = ''
	) {
	
	if !$host {
		$manage = true
	} elsif $host == $hostname {
		$manage = true
	} else {
		$manage = false
	}

	if $manage {
		case $ensure {
			'running': {
				lxc::container::create {
					$name:
						template   => $template,
						vgname     => $vgname,
						lvsize     => $lvsize,
						filesystem => $filesystem,
						opts       => $opts
				}
				lxc::container::autostart {
					$name:
						autostart => $autostart,
						require => Lxc::Container::Create[$name];
				}
				lxc::container::state {
					$name:
						state   => 'running',
						require => Lxc::Container::Create[$name];
				}
			}
			'stopped': {
				lxc::container::create {
					$name:
						template   => $template,
						vgname     => $vgname,
						lvsize     => $lvsize,
						filesystem => $filesystem,
						opts       => $opts
				}
				lxc::container::autostart {
					$name:
						autostart => $autostart,
						require => Lxc::Container::Create[$name];
				}
				lxc::container::state {
					$name:
						state   => 'stopped',
						require => Lxc::Container::Create[$name];
				}
			}
			'absent': {
				lxc::container::state {
					$name:
						state   => 'stopped';
				}
				lxc::container::destroy {
					$name:
						require => Lxc::Container::State[$name];
				}
				lxc::container::autostart {
					$name:
						autostart => false;
				}
			}
		}
	}
}

# Sets a container to start automatically
#
# @param bool $autostart
define lxc::container::autostart(
	$autostart = true
	) {
	if $autostart {
		$ensure = symlink
		$target = "/var/lib/lxc/${name}/config"
	} else {
		$ensure = absent
		$target = undef
	}
	file {
		"/etc/lxc/auto/$name":
			ensure  => $ensure,
			target  => $target;
	}
}

# Set a containers state
#
# @param stopped|running $state
define lxc::container::state(
	$state = 'running'
	) {
	case $state {
		'running': {
			exec {
				"lxc-start -d -n ${name}":
					onlyif => "test `lxc-info -n ${name} 2>/dev/null |grep state | awk ' { print \$2 } '` != 'RUNNING'";
			}
		}
		'stopped': {
			exec {
				"lxc-stop -n ${name}":
					onlyif => "test `lxc-info -n ${name} 2>/dev/null |grep state | awk ' { print \$2 } '` != 'STOPPED'";
			}
		}
	}
}

# Ensures, that a container exists
# @param string $template template name to use
# @param string $vgname   volume group name to use
# @param int    $lvsize   logical volume size in GB
define lxc::container::create(
	$template,
	$vgname,
	$lvsize,
	$filesystem = 'ext4',
	$opts = ''
	) {
	exec {
		"lxc-create-${name}":
			command => "lxc-create -n ${name} -t ${template} -B lvm --lvname ${name} --vgname ${vgname} --fstype ${filesystem} --fssize ${lvsize}G -- ${opts}",
			onlyif  => "test ! -d /var/lib/lxc/${name}",
			require => Class[ 'lxc::host' ];
	}
	exec {
		"lxc-resize-${name}":
			command => "lxc-stop -n ${name} && lvresize -L ${lvsize}G && e2fsck -f /dev/${vgname}/${name} && resize2fs /dev/${vgname}/${name}",
			onlyif  => "test -d /var/lib/lxc/${name} -a ${lvsize} -gt $(lvdisplay /dev// |grep 'LV Size'| awk ' { print $3 } ' | sed -e 's/\\.*//')",
			require => Class[ 'lxc::host' ];
	}
}

# Ensures, that a container is destroyed
define lxc::container::destroy() {
	exec {
		"lxc-destroy -f -n ${name}":
			onlyif => "test -d /var/lib/lxc/${name}",
			require => Class[ 'lxc::host' ];
	}
}
