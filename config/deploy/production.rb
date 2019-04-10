# default branch to deploy, it is recommended deploy with master
set :branch, 'develop'

# set your address here
set :server_address, '178.128.149.22'

# Not asks for password, expect that ssh is set up
ask(:password, nil, echo: false)

server fetch(:server_address), user: 'root', roles: %w[app db web]

set :nginx_server_name, fetch(:server_address)
set :puma_preload_app, true
