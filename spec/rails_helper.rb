ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.use_transactional_fixtures = false
  config.use_transactional_examples = false

  %i(request controller).each do |type|
    config.include Request::JsonHelpers, type: type
  end

  config.include Request::HeadersHelpers, type: :controller

  config.before(:each, type: :controller) do
    include_default_accept_headers
  end

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:mongoid].strategy = :truncation

    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
