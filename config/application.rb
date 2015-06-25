require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dandygame
  class Application < Rails::Application

    config.middleware.use Mobvious::Manager

    Mobvious.configure do |config|
      config.strategies = [ Mobvious::Strategies::MobileESP.new(:mobile_tablet_desktop) ]
    end

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.smtp_settings = {
        address:        "smtp.locum.ru",
        domain:         "dandygame.ru",
        port:           2525,
        user_name:      "info@dandygame.ru",
        authentication: "plain",
        openssl_verify_mode: 'none',
        enable_starttls_auto: true
    }


    #config.assets.precompile += %w( front.js .css )


    config.assets.paths << Rails.root.join("app", "assets", "fonts")

    initializer 'setup_asset_pipeline', :group => :all  do |app|
      # We don't want the default of everything that isn't js or css, because it pulls too many things in
      app.config.assets.precompile.shift

      # Explicitly register the extensions we are interested in compiling
      app.config.assets.precompile.push(Proc.new do |path|
                                          File.extname(path).in? [
                                                                     '.html', '.erb', '.haml',                 # Templates
                                                                     '.png',  '.gif', '.jpg', '.jpeg',         # Images
                                                                     '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
                                                                 ]
                                        end)
    end






    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.time_zone = "Moscow"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru
  end
end
