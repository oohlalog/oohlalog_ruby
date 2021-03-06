require 'net/http'
require 'json'
require 'socket'

class Oohlalog::Logger
  module Severity
    DEBUG   = 0
    INFO    = 1
    WARN    = 2
    ERROR   = 3
    FATAL   = 4
    UNKNOWN = 5
  end
  include Severity

  def initialize(buffer_size=100, level = DEBUG, options={})
    @api_key = Oohlalog.api_key
    if options.has_key? :api_key
      @api_key = options[:api_key]
    elsif options.has_key? "api_key"
      @api_key = options["api_key"]
    end

    @agent = Oohlalog.agent
    if options.has_key? :agent
        @agent = options[:agent]
    elsif options.has_key? "agent"
        @agent = options["agent"]
    end

    @tags =Oohlalog.tags
    @session_tag = Oohlalog.session_tag

    @secure = Oohlalog.secure
    @buffer_size = buffer_size
    @buffer = []
    self.level = level
  end

  def add(severity, message, category=nil, details=nil)
        log_message = message

        if message.nil? || message.to_s.empty?
            log_message = category
            category = nil
        end
        if category == message
            category = nil
        end

        session = Thread.current[:session_id]

        return if log_message.nil? || log_message.to_s.empty?

        if severity >= self.level
            if details.nil? && defined?(log_message.backtrace)
                details = log_message.backtrace.join("\n")
            end
            @buffer << {level: severity_string(severity), message: log_message.to_s.gsub(/\e\[(\d+)m/, ''), agent: @agent , category: category, details: details, timestamp:(Time.now.to_f * 1000).to_i, hostName: Socket.gethostname, token: session}
            check_buffer_size
            return
        end
  end

  Severity.constants.each do |severity|
    define_method severity.downcase do |message, category=nil, details=nil|
      add(Severity.const_get(severity), message, category, details)
    end
  end

  def level=(l)
    @level = l
  end

  def level
    @level
  end

  def severity_string(severity_level)
    Severity.constants.each do |severity|
      if Severity.const_get(severity) == severity_level
        return severity.downcase
      end
    end
    return "unknown"
  end

  def flush_buffer
    return if @buffer.size == 0

    payload = { logs: [] }
    Thread.new do
      while @buffer.size > 0
        entry = @buffer.shift
        payload[:logs] << entry
      end
      send_payload(payload)
    end
  end

private
  def send_payload(payload)
    begin
      request = Net::HTTP::Post.new("#{Oohlalog.path}?apiKey=#{@api_key || Oohlalog.api_key}",{'Content-Type' =>'application/json'})
      request.body = payload.to_json
      http_net = Net::HTTP.new(Oohlalog.host, Oohlalog.port)
      if @secure
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE # read into this
      end
      http_net.read_timeout = 5
      http_net.start {|http| http.request(request) }
    rescue Exception => ex
    #   puts "Oohlalog Exception**: #{ex}"
    end
  end

  def check_buffer_size
    if @buffer.size >= @buffer_size
      flush_buffer
    end
    reset_watchdog
  end

  def reset_watchdog
    terminate_watchdog
    init_watchdog
  end

  def terminate_watchdog
    if @watchdog.nil? == false
      @watchdog.terminate
      @watchdog = nil
    end
  end

  def init_watchdog
    @watchdog = Thread.new do
      sleep 5
      flush_buffer if @buffer.size > 0
    end
  end
end
