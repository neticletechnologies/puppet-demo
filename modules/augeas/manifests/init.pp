# Augeas is a tool, that lets you edit config files in a tree-like fashion. augeas-tools (the augtool binary) is the 
# command line tool for that. We use it to test configuration changes before adding them to Puppet.
class augeas {
	package {
		"augeas-tools":
			ensure => latest;
	}
	file {
		"/usr/share/augeas/lenses/dist/icingacfg.aug":
			source => "puppet:///modules/augeas/icingacfg.aug";
		"/usr/share/augeas/lenses/dist/icingaobjects.aug":
			source => "puppet:///modules/augeas/icingaobjects.aug";
	}
}