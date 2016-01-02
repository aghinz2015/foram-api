require File.expand_path('../boot', __FILE__)

require 'rails'

require 'active_model/railtie'
require 'active_job/railtie'
# require 'active_record/railtie'
require 'action_controller/railtie'
# require 'action_mailer/railtie'
# require 'action_view/railtie'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module ForamApi
  class Application < Rails::Application
    config.middleware.insert_before 0, 'Rack::Cors' do
      allow do
        origins '*'

        resource '*',
                 headers: :any,
                 methods: %i(head get post put patch delete options),
                 expose: %w(Link Total Per-Page)
      end
    end

    config.middleware.use Rack::Deflater

    config.autoload_paths += %W(
      #{config.root}/app/services
      #{config.root}/lib
    )

    config.generators do |g|
      g.test_framework :rspec,
        fixture:          true,
        view_specs:       false,
        helper_specs:     false,
        routing_specs:    false,
        controller_specs: true,
        request_specs:    true
      g.fixture_replacement :fabrication
      g.orm :mongoid
    end

    config.exceptions_app = routes

    config.cache_store = :redis_store, Rails.application.config_for(:redis)
  end
end
