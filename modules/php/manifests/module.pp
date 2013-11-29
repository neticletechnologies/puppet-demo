define php::module (
	$package
	) {
	package {
		$package:
			ensure => installed;
	}
}
