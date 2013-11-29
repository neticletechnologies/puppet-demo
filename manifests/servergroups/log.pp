node /^([a-z]+)-([a-z]+)-log([\d]+)\./ {
	include server::log
}

class server::log inherits server {
}
