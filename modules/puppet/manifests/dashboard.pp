class puppet::dashboard(
	$mysqlserver   = 'localhost',
	$mysqluser     = 'dashboard',
	$mysqlpassword,
	$mysqldb       = 'dashboard',
	) {
	include puppetlabs::repo
	include puppet::dashboard::install
	include puppet::dashboard::config
	include puppet::dashboard::database
	include puppet::dashboard::service
	
	Class['Puppetlabs::Repo']
	-> Class['install']
	-> Class['config']
	-> Class['database']
	-> Class['service']
}

class puppet::dashboard::install {
	package {
		"puppet-dashboard":
			ensure => installed;
		"rack":
			provider => gem,
			ensure   => '1.1.2';
		"libmysql-ruby":
			ensure => installed;
		"rdoc":
			provider => gem,
			ensure => installed;
	}
}

class puppet::dashboard::config {
	file {
		"/etc/puppet-dashboard/database.yml":
			ensure  => file,
			owner   => 'www-data',
			group   => 'www-data',
			mode    => 0640,
			content => template('puppet/dashboard/database.yml'),
			notify  => [ Service['puppet-dashboard'], Service['puppet-dashboard-workers'] ],
			require => Class[ "puppet::dashboard::install" ];
		"/etc/default/puppet-dashboard":
			ensure  => file,
			notify  => Service['puppet-dashboard'],
			source  => "puppet:///puppet/dashboard/default";
		"/etc/default/puppet-dashboard-workers":
			ensure  => file,
			notify  => Service['puppet-dashboard'],
			source  => "puppet:///puppet/dashboard/puppet-dashboard-workers";
	}
	puppet::master::conf {
		"reports":
			value => "http";
		"reporturl":
			value => "http://127.0.0.1:3000/reports/upload";
	}
}

class puppet::dashboard::database {
	exec {
		"dbmigrate":
			command => "rake RAILS_ENV=production db:migrate",
			cwd     => "/usr/share/puppet-dashboard",
			path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games",
			creates => "/var/lib/mysql/${mysqldb}/nodes.frm";
	}
}

class puppet::dashboard::service {
	service {
		puppet-dashboard:
			ensure => running;
		puppet-dashboard-workers:
			ensure => running;
	}
}
