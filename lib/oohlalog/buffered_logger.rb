module Oohlalog
  module BufferedLogger
      extend ActiveSupport::Concern
      included do
        @@oohla_logger ||= Oohlalog::Logger.new()
        alias_method_chain :add, :oohlalog
      end

      private

      def add_with_oohlalog(severity, message, prog_name, &block)
        if severity >= self.level
          @@oohla_logger.add(severity, message, nil)
        end
        add_without_oohlalog(severity, message, prog_name, &block)
      end

  end
end
