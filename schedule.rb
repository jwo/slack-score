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
		
      matchups =page
        .search("td.matchup")
        .select{|td| td.text =~ /#{team}/i }
        .map(&:parent)
        .map do |tr|

          element = tr.parent.parent.parent
          until element.attributes["class"].value  == "year-bg" do
            element = element.previous_sibling
          end

          date = element.text
          name = tr.search(".matchup").first.text
          time = tr.search(".tv-time-td").first.text
          channel = tr.search(".tv-online-td").first.text

          [date, name, time, channel]
        end
        .select do |matchup| 
          date        = Date.parse(matchup[0]) 
          start_date  = Date.today
          end_date    = 6.days.from_now
          (start_date..end_date).include? date
        end

      b = binding
      return ERB.new(File.read("./schedule.erb")).result(b)
    end
	end
end