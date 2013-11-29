define nginx::vhost::redirect(
	$target,
	$aliases               = [],
	$ensure                = 'enabled',
	$listen                = [
		'0.0.0.0:80'
	],
	$ssl                   = false,
	$ssl_certificate       = '',
	$ssl_certificate_key   = '',
	$error_page            = {},
	$error_log             = '',
	$extra                 = '',
	$check_status          = 301,
	) {
	nginx::vhost {
		$name:
			ensure              => $ensure,
			aliases             => $aliases,
			listen              => $listen,
			ssl                 => $ssl,
			ssl_certificate     => $ssl_certificate,
			ssl_certificate_key => $ssl_certificate_key,
			error_log  => $error_log,
			extra      => "rewrite ^(.*) ${target}\$1 permanent;",
			error_page => $error_page,
			check_status => $check_status,
	}
}
