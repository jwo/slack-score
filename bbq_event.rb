require 'celluloid/eventsource'

class BbqEvent
  include Celluloid

  def fetch

    @data = nil

    es = Celluloid::EventSource.new("http://99.187.135.99/luci/lm/stream") do |conn|
      #conn.on_open do
      #  puts "Connection was made"
      #end

      conn.on(:hmstatus) do |event|
        @data = event.data
      end

      #conn.on_message do |event|
      #  puts "Message: #{event.data}"
      #end

      #conn.on_error do |message|
      #  puts "Response status #{message[:status_code]}, Response body #{message[:body]}"
      #end

      #conn.on(:time) do |event|
      #  puts "The time is #{event.data}"
      #end
    end

    while @data.nil?
      sleep 1
    end

    @data

  end

end
