require 'pry'
require 'erb'
require 'mechanize'
require 'ostruct'
require 'active_support/all'

class Schedule

  def data(teams)
    teams = Array(teams)
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
    a.get("http://www.fbschedules.com/college-football-schedule/") do |page|
    
      return page
        .search("td.matchup")
        .select do |td| 
          a, b = td.text.gsub(/[\(\d\)]/, "").split(" at ").map(&:strip)
          [a,b].any? {|team| teams.include? team}
        end
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

          teams = name.gsub(/[\(\d\)]/, "").split(" at ").map(&:strip)

          [date, name, time, channel, teams]
        end
        .select do |matchup| 
          date        = Date.parse(matchup[0]) 
          start_date  = Date.today
          end_date    = 6.days.from_now
          (start_date..end_date).include? date
        end
        .map do |row|
          OpenStruct.new([:date, :game, :time, :channel, :teams].zip(row).to_h)
        end
    end
  end

	def when?(teams)
    matchups = data(teams)
    b = binding
    return ERB.new(File.read("./schedule.erb")).result(b)
	end
end