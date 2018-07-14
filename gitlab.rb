## GitLab configuration settings

external_url 'https://gitlab.jonathan-boudreau.com'
nginx['listen_port'] = 80

nginx['listen_https'] = false
nginx['http2_enabled'] = false
nginx['real_ip_trusted_addresses'] = ['138.197.153.75']

nginx['real_ip_header'] = 'X-Real-IP'
nginx['real_ip_recursive'] = 'on'
