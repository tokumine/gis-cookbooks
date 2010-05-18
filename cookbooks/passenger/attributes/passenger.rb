default.passenger[:nginx][:passenger_version] = "2.2.11"
default.passenger[:nginx][:nginx_version] = "0.8.36"
default.passenger[:root_path] = "/usr/lib/ruby/gems/1.8/gems/passenger-2.2.11" 
#default.passenger[:root_path] = "/usr/local/lib/ruby/gems/1.8/gems/passenger-2.2.11" 
default.passenger[:passenger_ruby] = "/usr/bin/ruby" 

default.passenger[:rails_env] = "production"

default.nginx[:dir]     = "/etc/nginx"
default.nginx[:log_dir] = "/var/log/nginx"
default.nginx[:user]    = "ubuntu"
default.nginx[:group]   = "ubuntu"
default.nginx[:binary]  = "/usr/sbin/nginx"
default.nginx[:gzip_types] = [ "text/plain", "text/css", "application/javascript", "application/x-javascript", "text/xml", "application/xml", "application/xml+rss", "text/javascript" ]
default.nginx[:version] = "0.8.36"
default.nginx[:expires][:enabled] = true
default.nginx[:expires][:regex] = '^/(javascripts|stylesheets|images|sprockets)[/\.]'
default.nginx[:expires][:time] = "max"
default.nginx[:extras] = ['lb_addresses']
default.nginx[:helpers] = ['headers', 'expires', 'maintenance', 'invalid_requests', 'ie', 'fcgi_params']
default.nginx[:maintenance][:bypass_host_regex] = "^projects|asset?"

default.nginx[:gzip] = "on"
default.nginx[:gzip_http_version] = "1.0"
default.nginx[:gzip_comp_level] = "2"
default.nginx[:gzip_proxied] = "any"

default.nginx[:keepalive] = "on"
default.nginx[:keepalive_timeout] = 8

default.nginx[:worker_processes] = 6
default.nginx[:worker_connections] = 2048
default.nginx[:server_names_hash_bucket_size] = 128
default.nginx[:conf_dir] = nginx[:dir] + "/conf.d"

default.web[:dir] = "/home/ubuntu/www"
default.web[:default_site] = "ppe"