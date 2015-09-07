require 'bundler'
Bundler.require
require './bbq_event'

class BbqBot

  def fetch

    future = BbqEvent.new.future.fetch
    data = JSON.parse(future.value)
    @set_temp  = data.fetch("set")
    @meat_temp = data.fetch("temps").find{|h| h["n"] == "Brisket" }.fetch("c")
    @amb_temp  = data.fetch("temps").find{|h| h["n"] == "Ambient" }.fetch("c")
    @pit_temp  = data.fetch("temps").find{|h| h["n"] == "Pit Temp" }.fetch("c")

    self
  end

  def formatted
    data = {
      pit: @pit_temp,
      meat: @meat_temp,
      ambient: @amb_temp,
      set: @set_temp,
    }

    rows = ['```']
    data.each do |key, value|
      rows << "#{key.to_s.ljust(10)} : #{value}"
    end

    rows << '```'

    rows.join("\n")

  end

end
