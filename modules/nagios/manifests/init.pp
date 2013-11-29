# Icinga base class
class nagios {
	include nagios::install
	include nagios::import
	include nagios::permissions
	include nagios::config
	include nagios::removedefaults
	include nagios::generic
	include nagios::service

	Class['install']
	-> Class['import']
	-> Class['permissions']
	-> Class['config']
	-> Class['removedefaults']
	-> Class['generic']
	-> Class['service']
}
