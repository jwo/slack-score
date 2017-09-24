require 'bundler'
Bundler.require
Dotenv.load

require 'http'
require 'erb'
require 'pry'
require 'ostruct'

class SlackScore

  def formatted_matchups
    games = matchups
    b = binding
    ERB.new(File.read("./scores.erb")).result(b)
  end

  def formatted_rankings
    teams = rankings.map{|g| OpenStruct.new(g)}
    b = binding
    ERB.new(File.read("./rankings.erb")).result(b)
  end

  def live_scoring
    {
        "version"=> "1.5.0",
        "device"=> "iOS",
        "msgs"=> [{
          "method"=> "getLiveScoringStats",
          "msgId"=> "newView",
          "data"=> {
            "newView"=> true
          }
        }]
      }
  end

  def detail_payload 
      {
      "version"=> "2",
      "device"=> "iOS",
      "msgs"=> [
          {
              "method"=> "getLeagueHomeInfo",
              "msgId"=> "2",
              "data"=> {}
          }
      ]}
  end


  def fetch payload
    auth_payload = {"version"=>"2", "device"=>"iOS", "msgs"=>[{"method"=>"login", "msgId"=>"ID", "data"=>{"u"=>"#{ENV.fetch("USERNAME")}","p"=>"#{ENV.fetch("PASSWORD")}"}}]}

    response = HTTP.post('http://www.fantrax.com/fxma/req', json: auth_payload)

    fantrax_cookie = response.cookies.find {|c| c.name =="FANTRAX_REMEMBERS" }
    fantrax_cookie = {fantrax_cookie.name => fantrax_cookie.value}

    league_id = JSON.parse(response.body).fetch("responses").first.fetch("data").fetch("leagues").first.fetch("leaguesTeams").first.fetch("leagueId")



    league_response = JSON.parse HTTP
                      .cookies(fantrax_cookie)
                      .post("http://www.fantrax.com/fxma/req?leagueId=#{league_id}", json: payload)
      # league_data =                league_response.body

  end

  def rankings
    fetch(detail_payload)
      .fetch("responses")
      .find{|j| j["msgId"].to_i == 2}
      .fetch("data")
      .fetch("standings")
      .first["COMBINED"]
  end

  def schedule
    data = fetch live_scoring
    team_id = data
      .fetch("responses")
      .first
      .fetch("data")
      .fetch("ownTeamIds")
      .first

    players = data
      .fetch("responses")
      .first
      .fetch("data")
      .fetch("scorersPerTeam")
      .fetch("ACTIVE")
      .fetch(team_id)
      .map{|player| [:id, :name, :team, :position].zip(player).to_h }
      # .map do |player|

      # end

    
    teams = data
      .fetch("responses")
      .first
      .fetch("data")
      .fetch("statsPerTeam")
      .fetch(team_id)
      .fetch("ACTIVE")
      .fetch("gameStatusMap")
      .map do |key, value|
        id = key
        name = value.split("|").first
        pending = name.include? "~"

        if pending
          team, starts = name.split("~")
          starts = starts.chars
          starts.pop(3)
          starts = Time.at starts.join.to_i
          starts = starts.strftime("%b %e, %l:%M %p")
          {id: id, name: [team, starts].join(" - ")}
        else
          {id: id, name: name}
        end

      end

  end

  def matchups
    table_data_with_weird_ids = fetch(detail_payload)
      .fetch("responses")
      .find{|j| j["msgId"].to_i == 2}
      .fetch("data")
      .fetch("matchups")
      .fetch("tableData")
    games = []

    table_data_with_weird_ids.each do |row_array|
      game = {}

      game[name_for_team_id(row_array[1])] = row_array[2]
      game[name_for_team_id(row_array[3])] = row_array[4]
      games << game

    end

    games
  end

  def name_for_team_id(team_id)
    @data.fetch("standings").first.fetch("COMBINED").find{|j| j["teamId"].to_s == team_id.to_s}["team"]
  end
end
