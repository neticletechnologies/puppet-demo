class puppet::master (
	$bindaddress = '0.0.0.0',
	$dbserver    = 'localhost',
	$dbuser      = 'puppet',
	$dbpassword  = '',
	$dbname      = 'puppet'
	) {
	include puppet::master::install
	class {
		puppet::master::config:
			bindaddress => $bindaddress,
			dbserver    => $dbserver,
			dbuser      => $dbuser,
			dbpassword  => $dbpassword,
			dbname      => $dbname
	}
	include puppet::master::service
	include puppet::master::clean
	include puppet::master::monitor

	Class ['install']
	-> Class ['config']
	-> Class ['service']
	-> Class ['clean']
	-> Class ['monitor']
}

class puppet::master::install {
	package {
		"puppetmaster":
			ensure => latest;
		"ruby-mysql":
			ensure => present;
		"ruby-activerecord":
			ensure => present;
		"rubygems":
			ensure => present;
		"deep_merge":
			ensure   => present,
			provider => gem,
			require  => Package['rubygems'];
	}
}

define puppet::master::conf(
	$value
	) {
	augeas {
		"puppet-master/${name}":
			context => "/files/etc/puppet/puppet.conf/master",
			onlyif  => "get ${name} != '${value}'",
			changes => "set ${name} '${value}'",
			require => File['/etc/puppet/puppet.conf'],
			notify  => Service['puppetmaster'];
	}
}

class puppet::master::clean {
	cron {
		"puppet clean reports":
			command => 'cd /var/lib/puppet/reports && find . -type f -name \*.yaml -mtime +2 -print0 | xargs -0 -n50 /bin/rm -f',
			user => root,
			hour => 21,
			minute => 22;
	}
}

class puppet::master::config(
	$bindaddress = '0.0.0.0',
	$dbserver    = 'localhost',
	$dbuser      = 'puppet',
	$dbpassword  = '',
	$dbname      = 'puppet'
	) {
	file {
		"/etc/puppet/autosign.conf":
			ensure  => file,
			content => template("puppet/autosign.conf.erb"),
			notify  => Service['puppetmaster'];
	}
	puppet::master::conf {
		storeconfigs:
			value => "true";
		dbadapter:
			value => 'mysql';
		dbserver:
			value => 'localhost';
		dbname:
			value => $dbname;
		dbuser:
			value => $dbuser;
		dbpassword:
			value => $dbpassword;
		bindaddress:
			value => $bindaddress;
	}
	augeas {
		"puppet-master/fileserver/files/path":
			context => "/files/etc/puppet/fileserver.conf/files",
			onlyif  => "get path != '/etc/puppet/files'",
			changes => "set path '/etc/puppet/files'",
			notify  => Service['puppetmaster'];
		"puppet-master/fileserver/files/allow":
			context => "/files/etc/puppet/fileserver.conf/files",
			onlyif  => "get allow != '*.${domain}'",
			changes => "set allow '*.${domain}'",
			notify  => Service['puppetmaster'];
		"puppet-master/fileserver/plugins/allow":
			context => "/files/etc/puppet/fileserver.conf/plugins",
			onlyif  => "get allow != '*.${domain}'",
			changes => "set allow '*.${domain}'",
			notify  => Service['puppetmaster'];
	}
}

class puppet::master::service {
	service {
		"puppetmaster":
			ensure => running;
	}
}

class puppet::master::monitor {
	include nagios::monitor::puppetmaster
}

