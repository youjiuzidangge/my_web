require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'    # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)
require 'mina/puma'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'my_web'
set :domain, '118.25.39.227'
set :deploy_to, '/var/www/my_web'
set :repository, 'https://github.com/youjiuzidangge/my_web.git'
set :branch, 'master'
set :user, 'deploy'

# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# Fill in the names of the files and directories that will be symlinks to the shared directory. 
# All folders will be created automatically on Mina setup.
# Don’t forget to add a path to the uploads folder if you are using Dragonfly or CarrierWave.
# Otherwise, you will lose your uploads on each deploy.
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

set :shared_dirs, [ 'config/wx_cert',
                    'config/ali_cert',
                    'log',
                    'logs',
                    'tmp',
                    'vendor/bundle',
                    'node_modules',
                    # 'public',
                    'public/assets',
                    'public/packs',
                    'public/uploads',
                    'public/front'
                    ]


set :shared_files, ['config/database.yml',
                    'config/puma.rb',
                    'config/secrets.yml',
                    '.env'
                    ]

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # command %{rbenv install 2.3.0 --skip-existing}
  command %[mkdir -p "#{fetch(:deploy_to)}/shared/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/log"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/logs"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/logs"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/config"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/config/wx_cert"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/config/wx_cert"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/config/ali_cert"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/config/ali_cert"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/config"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/tmp"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/tmp"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/vendor/bundle"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/vendor/bundle"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/node_modules"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/node_modules"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/public"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/public"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/public/assets"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/public/assets"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/public/packs"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/public/packs"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/public/uploads"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/public/uploads"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/public/front"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/public/front"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/public/front_new"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/public/front_new"]

  command %[touch "#{fetch(:deploy_to)}/shared/config/database.yml"]
  command  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  # command %[touch "#{fetch(:deploy_to)}/shared/config/mongoid.yml"]
  # command  %[echo "-----> Be sure to edit 'shared/config/mongoid.yml'."]

  command %[touch "#{fetch(:deploy_to)}/shared/config/puma.rb"]
  command  %[echo "-----> Be sure to edit 'shared/config/puma.rb'."]

  command %[touch "#{fetch(:deploy_to)}/shared/config/wx_cert/apiclient_cert.p12"]
  command  %[echo "-----> Be sure to edit 'shared/config/wx_cert/apiclient_cert.p12'."]

  command %[touch "#{fetch(:deploy_to)}/shared/config/ali_cert/rsa_private_key.pem"]
  command  %[echo "-----> Be sure to edit 'shared/config/ali_cert/rsa_private_key.pem'."]


  command %[mkdir -p "#{fetch(:deploy_to)}/shared/tmp/sockets"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/tmp/sockets"]

  # tmp/sockets/puma.state
  command %[touch "#{fetch(:deploy_to)}/shared/tmp/sockets/puma.state"]
  command  %[echo "-----> Be sure to edit 'shared/tmp/sockets/puma.state'."]

  # log/puma.stdout.log
  command %[touch "#{fetch(:deploy_to)}/shared/log/puma.stdout.log"]
  command  %[echo "-----> Be sure to edit 'shared/log/puma.stdout.log'."]

  # log/puma.stdout.log
  command %[touch "#{fetch(:deploy_to)}/shared/log/puma.stderr.log"]
  command  %[echo "-----> Be sure to edit 'shared/log/puma.stderr.log'."]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/tmp/pids"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/tmp/pids"]
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
      #invoke :'puma:custom_start'
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

namespace :puma do
  task :custom_start => :environment do
    command %[
      if [ -e '#{fetch(:pumactl_socket)}' ]; then
        echo 'Puma is already running!';
      else
        if [ -e '#{fetch(:puma_config)}' ]; then
          cd '#{fetch(:current_path)}' && #{fetch(:puma_cmd)} -d -e #{fetch(:puma_env)} -C #{fetch(:puma_config)}
          sleep 1
        else
          echo 'Puma config is required'
          exit 1
        fi
      fi
    ]
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
