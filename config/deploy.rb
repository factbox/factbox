# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, 'factbox'
set :repo_url, 'git@github.com:factbox/factbox.git'

set :deploy_to, '/root/deploy/factbox/'

append :linked_files, 'config/database.yml', 'config/secrets.yml'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

set :nginx_sites_available_path, '/etc/nginx/sites-available'
set :nginx_sites_enabled_path, '/etc/nginx/sites-enabled'

set :rvm_ruby_version, '2.5.1'

namespace :puma do
  desc 'Create Puma dirs'
  task :create_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end
  desc 'Restart Nginx'
  task :nginx_restart do
    on roles(:app) do
      execute 'sudo service nginx restart'
    end
  end
  before :start, :create_dirs
  after :start, :nginx_restart
end
