# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oohlalog/version'

Gem::Specification.new do |gem|
  gem.name          = "oohlalog"
  gem.version       = Oohlalog::VERSION
  gem.authors       = ["David Estes"]
  gem.email         = ["destes@bcap.com"]
  gem.description   = "Rails/Ruby Logger Tie-in for OohLaLog.com"
  gem.summary       = "The OohLaLog service allows for cloud logging from multiple servers. This easy tie-in makes work for the developer minimal and provides advanced functionality, such as counters, search, live log tail, alerts, and more."
  gem.homepage      = "http://www.oohlalog.com"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
