require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BookKeeper
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.SMS = {
      URI: "https://api.textlocal.in/send/?",
      API_KEY: "uOV8AljJU+Y-YzbbPcmKKG7wEjgwy2S6MBGGgBWXXz	"
    }

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :delete, :put, :patch, :options]
      end
    end
    config.action_mailer.asset_host = config.action_controller.asset_host
    # config.action_mailer.default_url_options = { host: "onacc.com" }

    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.smtp_settings = {
      address: 'smtp.sendgrid.net',
      port: '587',
      authentication: :plain,
      user_name: "varshatyagi",
      password: "newput2015",
      domain: 'heroku.com',
      enable_starttls_auto: true
    }
  end
end
