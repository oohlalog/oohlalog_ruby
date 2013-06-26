module Oohlalog
  if defined?(Rails) && Rails::VERSION::MAJOR == 3
    require 'oohlalog/buffered_logger'
    class Railtie < Rails::Railtie
      initializer "oohlalog" do |app|
        ActiveSupport::BufferedLogger.instance_eval do
          include BufferedLogger
        end
      end
    end
  elsif defined?(Rails) && Rails::VERSION::MAJOR == 4
    require 'logger'
    require 'oohlalog/buffered_logger'
    class Railtie < Rails::Railtie
      initializer "oohlalog" do |app|
        ::Logger.instance_eval do
          include BufferedLogger
        end
      end
    end
  end

end
