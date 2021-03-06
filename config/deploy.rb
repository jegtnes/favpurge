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

set :linked_files, %w(.env)
set :linked_dirs, %w(public)

namespace :deploy do

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

namespace :npm do
  task :install do
    on roles :app do
      within release_path do
        execute "/home/ajms/.nvm/v0.10.26/bin/node /home/ajms/.nvm/v0.10.26/bin/npm install"
      end
    end
  end
end

namespace :gulp do
  task :build do
    on roles :app do
      within release_path do
        with path: "#{release_path}/node_modules/.bin:$PATH" do
          execute :gulp, :build
        end
      end
    end
  end
end

after "deploy:updating", "npm:install"
after "deploy:updating", "gulp:build"
