# Oohlalog

A gem designed to tie into the Oohlalog logging service.

## Installation

Add this line to your application's Gemfile:

    gem 'oohlalog'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oohlalog

## Usage

### Rails 3 & Rails 4 (Edge)

This gem automatically ties into the rails standard BufferedLogger. Set your configuration options in your environment file.

```ruby
  Oohlalog.api_key = "YOUR API KEY HERE"
```

**NOTE:** If you wish to not inject the oohlalog logger into the standard rails logger, you may do so by adding the following to your `application.rb` file.

```ruby
  Oohlalog.inject_rails = false
```

### Standard Ruby

Oohlalog is designed as an independent logging class. You can use it this way or tie it into the main ruby logger.

To run an independent instance simply create a new log object

```ruby
  require 'oohlalog'
  Oohlalog.api_key = "YOUR API KEY HERE"

  logger = Oohlalog::Logger.new(100, Oohlalog::Logger::DEBUG) #First argument is the buffer size, second is log level

  logger.warn("Warning Log")
  logger.info("Info log")
  logger.debug("Debug log message")
  logger.error("Error message")
  logger.fatal("Fatal error message")
```

### Secure Mode

In many cases it may be prudent to ensure secure log communication with our servers. For these high security situations you can enable SSL communication with the `secure` configuration option.

```ruby
Oohlalog.secure = true
```

TODO: Implement Counter support


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
