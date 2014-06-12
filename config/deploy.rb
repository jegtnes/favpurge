# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'favpurge'
set :repo_url, 'git@github.com:jegtnes/favpurge.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/ajms/webapps/aj_favpurge/app'
set :app_root, '/home/ajms/webapps/aj_favpurge'
set :host_root, '/home/ajms'
set :tmp_dir, "#{fetch(:host_root)}/tmp"

set :user, 'ajms'
set :scm_username, 'jegtnes'
set :use_sudo, false

set :pty, true

set :linked_files, %w{(./.env.production)}

namespace :deploy do

  after :linked_files, :env_setup do
    on roles(:app), in: :sequence do
      execute "mv #{fetch(:deploy_to)}/.env.production #{fetch(:deploy_to)}/.env"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "#{fetch(:app_root)}/bin/restart"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

end
