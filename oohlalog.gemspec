# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oohlalog/version'

Gem::Specification.new do |gem|
  gem.name          = "oohlalog"
  gem.version       = Oohlalog::VERSION
  gem.authors       = ["David Estes"]
  gem.email         = ["destes@redwindsw.com"]
  gem.description   = "Logger for Ooohlalog.com"
  gem.summary       = "Temporary summary"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
