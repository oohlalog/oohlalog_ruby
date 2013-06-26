require 'net/http'
require 'json'

class Oohlalog::Counter
  def initialzie
  end

  def increment(code,counter=1)
    Thread.new do
      begin
        request = Net::HTTP::Post.new("/api/counter/increment?apiKey=#{Oohlalog.api_key}&incr=#{counter}",{'Content-Type' =>'application/json'})

        http_net = Net::HTTP.new(Oohlalog.host, Oohlalog.port)
        http_net.read_timeout = 5
        http_net.start {|http| http.request(request) }
      rescue
        # puts "Oohlalog Exception**:"
      end
    end
  end
end
