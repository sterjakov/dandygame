# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'dandygame'
set :repo_url, 'sterjakov@78.47.135.90:~/git/dandygame.git/'
set :deploy_to, '/home/sterjakov/sites/dandygame'

set :default_env, { rvm_bin_path: '~/.rvm/bin' }

set :scm, :git

set :branch, 'master'

set :keep_releases, 5

set :format, :pretty
set :log_level, :debug
set :pty, true

set :unicorn_config_path, 'config/unicorn.rb'
set :unicorn_pid, "/home/sterjakov/sites/dandygame/shared/pids/unicorn.pid"

set(:shared_children, [])



namespace :deploy do

  desc "Create symlinks"

  task :create_symlinks do

    on roles :all do

      # Для фотографий
      execute "rm -rf #{release_path}/public/uploads"

      execute "ln -nfs #{shared_path}/public/uploads #{release_path}/public/uploads"

      # Конфиг БД
      execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"

      # Секретный ключ
      execute "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"

    end

  end

  desc "Restart unicorn"

  task :restart do

    on roles :all do

      execute "sh /home/sterjakov/sites/unicorn-stop.sh; sh /home/sterjakov/sites/unicorn-start.sh;"

    end

  end

  desc "Start unicorn"

  task :start_unicorn do

    on roles :all do

      execute ". /home/sterjakov/sites/unicorn-start.sh"

    end

  end

  desc "Stop unicorn"

  task :stop_unicorn do

    on roles :all do

      execute ". /home/sterjakov/sites/unicorn-stop.sh"

    end

  end


end

after("deploy:updating", "deploy:create_symlinks")
after("deploy:finished", "deploy:restart")

#### ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
