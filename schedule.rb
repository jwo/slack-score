require 'pry'
require 'erb'
require 'mechanize'
require 'active_support/all'

class Schedule
	def when?(team)
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
    a.get("http://www.fbschedules.com/college-football-schedule/") do |page|

      matchups = []
		
      page.search(".year-bg").each do |title|

        if Date.parse(title.text) <= 5.days.from_now

          container = title.next_sibling
          matchups += container
            .search("td.matchup")
            .select{|td| td.text =~ /#{team}/i }
            .map(&:parent)
            .map do |tr|
              date = title.text
              name = tr.search(".matchup").first.text
              time = tr.search(".tv-time-td").first.text
              channel = tr.search(".tv-online-td").first.text

              [date, name, time, channel]
            end
        end
      end
      b = binding
      return ERB.new(File.read("./schedule.erb")).result(b)
    end
	end
end