source 'https://rubygems.org'

ruby '2.2.1'

gem 'rails', '4.2.1'
gem 'rails-api'
gem 'rack-cors'
gem 'puma'
gem 'pg'
gem 'mongoid', '~> 4.0.0'
gem 'active_model_serializers', '~> 0.8.0'

group :development do
  gem 'spring'
  gem 'capistrano-rails', '~> 1.1.3',   :require => false
  gem 'capistrano-bundler', '~> 1.1.4', :require => false
  gem 'capistrano-rbenv', '~> 2.0.3',   :require => false
  gem 'capistrano3-puma',               :require => false
end

group :development, :test do
  gem 'pry'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.0'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'fabrication'
  gem 'faker'
  gem 'database_cleaner'
  gem 'timecop'
  gem 'shoulda-matchers'
  gem 'mongoid-rspec', '~> 2.1.0'
end

group :production do
  gem 'rails_12factor'
end
