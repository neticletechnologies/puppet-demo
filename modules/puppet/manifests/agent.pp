class puppet::agent {
	include puppet::agent::install
	include puppet::agent::config
	include puppet::agent::service
	Class ['install']
	-> Class ['config']
	-> Class ['service']
}

class puppet::agent::install {
	package {
		"puppet":
			ensure => latest;
	}
	file {
		"/var/cache/puppet":
			ensure => directory;
		"/var/cache/puppet/package":
			ensure => directory;
	}
}

class puppet::agent::config {
	file {
		"/etc/default/puppet":
			ensure  => file,
			source  => "puppet:///modules/puppet/default";
		"/etc/puppet/puppet.conf":
			ensure  => file;
		"/etc/puppet/auth.conf":
			ensure  => file,
			content => template('puppet/auth.conf.erb');
		"/etc/hiera.yaml":
			ensure => symlink,
			target => "/etc/puppet/hiera.yaml";
	}
	augeas {
		"puppet-agent/pluginsync":
			context => "/files/etc/puppet/puppet.conf/main",
			onlyif  => "get pluginsync != 'true'",
			changes => "set pluginsync 'true'",
			notify  => Service['puppet'],
			require => File['/etc/puppet/puppet.conf'];
		"puppet-agent/listen":
			context => "/files/etc/puppet/puppet.conf/main",
			onlyif  => "get listen == 'true'",
			changes => "rm listen",
			notify  => Service['puppet'],
			require => File['/etc/puppet/puppet.conf'];
	}
}

class puppet::agent::service {
	$hour1 = fqdn_rand(12)
	cron { "puppetclient1":
		command => "/usr/sbin/puppetd --onetime --no-daemonize",
		user    => root,
		minute  => fqdn_rand(60),
		hour    => $hour1;
	}

	$hour2 = ( $hour1 + 12 )
	cron { "puppetclient2":
		command => "/usr/sbin/puppetd --onetime --no-daemonize",
		user    => root,
		minute  => fqdn_rand(60),
		hour    => $hour2;
	}

	cron {
		"killdefunct":
			command => "ps auwfx | grep -B 1 '<defunct>' |grep 'puppetd --onetime' | awk ' { print \$2 } ' | xargs -i kill -9 {} 2>/dev/null",
			user    => root,
			minute  => '*';
	}

	service {
		"puppet":
			ensure    => stopped,
			enable    => false,
			require   => [
				Cron['puppetclient1'],
				Cron['puppetclient2'],
			];
	}
}
