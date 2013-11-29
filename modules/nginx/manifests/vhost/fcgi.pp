define nginx::vhost::fcgi(
	$fastcgi_pass,
	$vhost         = '',
	$aliases       = [],
	$root          = undef,
	$ensure        = 'enabled',
	$filename      = undef,
	$locationmatch = '~ \.php$',
	$index         = 'index.php index.html',
	$fastcgi_index = 'index.php',
	$fastcgi_param = {
		'SCRIPT_FILENAME'   => '$document_root$fastcgi_script_name',
		'QUERY_STRING'      => '$query_string',
		'REQUEST_METHOD'    => '$request_method',
		'CONTENT_TYPE'      => '$content_type',
		'CONTENT_LENGTH'    => '$content_length',
		'SCRIPT_NAME'       => '$fastcgi_script_name',
		'REQUEST_URI'       => '$request_uri',
		'DOCUMENT_URI'      => '$document_uri',
		'DOCUMENT_ROOT'     => '$document_root',
		'SERVER_PROTOCOL'   => '$server_protocol',
		'GATEWAY_INTERFACE' => 'CGI/1.1',
		'SERVER_SOFTWARE'   => 'nginx/$nginx_version',
		'REMOTE_ADDR'       => '$remote_addr',
		'REMOTE_PORT'       => '$remote_port',
		'SERVER_ADDR'       => '$server_addr',
		'SERVER_PORT'       => '$server_port',
		'SERVER_NAME'       => '$server_name',
		'REDIRECT_STATUS'   => '200',
	},
	$listen        = [
		'0.0.0.0:80'
	],
	$ssl                 = false,
	$ssl_certificate     = '',
	$ssl_certificate_key = '',
	$client_max_body_size  = '150m',
	$error_page            = {},
	$error_log             = '',
	$set_real_ip_from      = [],
	$real_ip_header        = 'X-Forwarded-For',
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
			root                => $root,
			index               => $index,
			location => {
				"$locationmatch" => {
					'fastcgi_index' => $fastcgi_index,
					'fastcgi_pass'  => $fastcgi_pass,
					'fastcgi_param' => $fastcgi_param,
				}
			},
			error_log  => $error_log,
			extra      => $extra,
			error_page => $error_page,
			set_real_ip_from => $set_real_ip_from,
			real_ip_header   => $real_ip_header,
			check_status     => $check_status,
			include          => $include,
	}
}
