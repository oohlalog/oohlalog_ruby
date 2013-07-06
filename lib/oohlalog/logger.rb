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


    @buffer_size = buffer_size
    @buffer = []
    self.level = level
  end

  def add(severity, message, category=nil, details=nil)
    return if message.nil? || message.empty?
    if severity >= self.level
      @buffer << {level: severity_string(severity), message: message.gsub(/\e\[(\d+)m/, '') , category: category, details: details, timestamp:Time.now.to_i * 1000, hostName: Socket.gethostname}
      check_buffer_size
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
      http_net.read_timeout = 5
      http_net.start {|http| http.request(request) }
    rescue Exception => ex
      # puts "Oohlalog Exception**: #{ex}"
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
