module Oohlalog
  if defined?(Rails) && Rails::VERSION::MAJOR == 3
    require 'oohlalog/buffered_logger'
    class Railtie < Rails::Railtie
      initializer "oohlalog", :after => :load_config_initializers do |app|
        if Oohlalog.inject_rails && Oohlalog.api_key
            if Oohlalog.agent == 'ruby'
                Oohlalog.agent = 'rails'
            end
          ActiveSupport::BufferedLogger.instance_eval do
            include BufferedLogger
          end
        end
      end
    end
  elsif defined?(Rails) && Rails::VERSION::MAJOR == 4
    require 'logger'
    require 'oohlalog/buffered_logger'
    class Railtie < Rails::Railtie
      initializer "oohlalog", :after => :load_config_initializers do |app|
        if Oohlalog.inject_rails && Oohlalog.api_key
            if Oohlalog.agent == 'ruby'
                Oohlalog.agent = 'rails'
            end
          ::Logger.instance_eval do
            include BufferedLogger
          end
        end
      end
    end
  end

end
