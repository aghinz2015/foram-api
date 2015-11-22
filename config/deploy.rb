# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'foram_api'
set :repo_url,    'https://github.com/aghinz2015/foram-api.git'
set :branch,      ENV['BRANCH_NAME'] || :master
set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :linked_files, fetch(:linked_files, []).push(
  '.env',
  'config/mongoid.yml',
  'config/secrets.yml'
)

set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/cache',
  'tmp/pids',
  'tmp/sockets'
)

# rbenv

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.1'

# slack

set :slack_webhook,  ENV['SLACK_WEBHOOK_URL']
set :slack_channel,  '#hooks'
set :slack_username, 'Deployer'
