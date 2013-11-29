define nginx::vhost::proxy(
	$proxy_pass,
	$vhost                 = '',
	$aliases               = [],
	$ensure                = 'enabled',
	$root                  = undef,
	$filename              = undef,
	$listen                = [
		'0.0.0.0:80'
	],
	$ssl                   = false,
	$ssl_certificate       = '',
	$ssl_certificate_key   = '',
	$proxy_set_header      = {
		'Host'            => '$host',
		'X-Forwarded-For' => '$remote_addr',
	},
	$client_max_body_size  = '150m',
	$proxy_buffering       = 'on',
	$proxy_buffers         = '8 16k',
	$proxy_buffer_size     = '32k',
	$proxy_max_temp_file_size = '1024m',
	$proxy_connect_timeout = 15,
	$proxy_read_timeout    = 60,
	$error_page            = {},
	$error_log             = '',
	$include               = [],
	$extra                 = '',
	$check_status          = 200,
	) {
	if ($vhost == '') {
		$realname = $name
	} else {
		$realname = $vhost
	}
	nginx::vhost {
		$name:
			ensure              => $ensure,
			vhost               => $realname,
			filename            => $name,
			aliases             => $aliases,
			listen              => $listen,
			ssl                 => $ssl,
			ssl_certificate     => $ssl_certificate,
			ssl_certificate_key => $ssl_certificate_key,
			location => {
				'/'  => {
					proxy_pass            => $proxy_pass,
					proxy_set_header      => $proxy_set_header,
					client_max_body_size  => $client_max_body_size,
					proxy_buffering       => $proxy_buffering,
					proxy_buffers         => $proxy_buffers,
					proxy_buffer_size     => $proxy_buffer_size,
					proxy_connect_timeout => $proxy_connect_timeout,
					proxy_read_timeout    => $proxy_read_timeout,
					proxy_max_temp_file_size => $proxy_max_temp_file_size,
				}
			},
			error_log  => $error_log,
			extra      => $extra,
			error_page => $error_page,
			check_status => $check_status,
			include => $include,
	}
}
