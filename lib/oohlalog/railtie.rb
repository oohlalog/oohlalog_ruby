module Oohlalog
  if defined?(Rails) && Rails::VERSION::MAJOR == 3
    require 'oohlalog/buffered_logger'
    class Railtie < Rails::Railtie
      initializer "oohlalog" do |app|
        if Oohlalog.inject_rails && Oohlalog.api_key
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
      initializer "oohlalog" do |app|
        if Oohlalog.inject_rails && Oohlalog.api_key
          ::Logger.instance_eval do
            include BufferedLogger
          end
        end
      end
    end
  end

end
