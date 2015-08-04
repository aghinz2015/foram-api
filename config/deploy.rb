# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'foram_api'
set :repo_url, 'ssh://git@stash.iisg.agh.edu.pl:7999/pp2015/foram_api.git'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.1'

set :branch, ENV['BRANCH_NAME'] || :master

set :linked_files, fetch(:linked_files, []).push(
  'config/database.yml',
  'config/mongoid.yml',
  'config/secrets.yml'
)

set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/cache',
  'tmp/pids',
  'tmp/sockets'
)

set :default_env, { path: "/opt/ruby/bin:$PATH" }
