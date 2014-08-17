require 'rubygems'
require 'oohlalog/version'
require 'oohlalog/logger'
require 'oohlalog/counter'
require 'oohlalog/railtie'

module Oohlalog
  @host = "api.oohlalog.com"
  @port = 80
  @path = "/api/logging/save.json"
  @api_key = nil
  @agent = "ruby"
  @inject_rails = true
  @secure = false
  @tags = nil
  @session_tag = nil
  class << self
    attr_accessor :api_key, :host, :port, :path, :inject_rails, :agent, :secure, :tags, :session_tag
  end
end
