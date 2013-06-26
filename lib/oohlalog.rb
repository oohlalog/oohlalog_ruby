require 'rubygems'
require 'oohlalog/version'
require 'oohlalog/logger'
require 'oohlalog/counter'
require 'oohlalog/railtie'

module Oohlalog
  @host = "oohlalog.com"
  @port = 80
  @path = "/api/logging/save.json"
  @api_key = nil
  class << self
    attr_accessor :api_key, :host, :port, :path
  end
end
