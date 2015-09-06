require 'bundler'
Bundler.require

class Sagarin
  def fetch
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    things = []

    a.get(url) do |page|

      fonts = page.search("font")
      (1..150).each do |i|

        found = fonts.find {|f| f.text =~ /&nbsp #{i.to_s.rjust(2)} / && f.text.length <= 40}
        next unless found

        parts = found.text.split(' ')
        level = parts[parts.length - 2]


        # get right of "A" and "="
        2.times { parts.pop }

        

        if level == "A"
          things << parts[2..-1].join(" ") # join ohio state on
        end

      end

    end

    things
    
  end

  def url
    "http://www.usatoday.com/sports/ncaaf/sagarin/"
  end
end


