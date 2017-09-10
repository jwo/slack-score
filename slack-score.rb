require 'bundler'
Bundler.require
Dotenv.load

require './slack-score-api'
require './sagarin'
require './bbq_bot'
require './insult'


Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  fail 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

client = Slack::Web::Client.new

client.auth_test

general_channel = client.channels_list['channels'].detect { |c| c['name'] == 'scorebot-test' }

client = Slack::RealTime::Client.new

client.on :hello do
  puts "Successfully connected, welcome '#{client.self['name']}' to the '#{client.team['name']}' team at https://#{client.team['domain']}.slack.com."
end

client.on :message do |data|

  username = client.users.find{|u| u["id"] == data['user']}["name"]

  case data['text']
  when /score me/i then

    client.typing channel: data['channel']

    username = client.users.find{|u| u["id"] == data['user']}["name"]

    scores = SlackScore.new.formatted_matchups
    client.message channel: data['channel'], text: scores

  when /rankings/i then

    client.typing channel: data['channel']

    username = client.users.find{|u| u["id"] == data['user']}["name"]

    scores = SlackScore.new.formatted_rankings
    client.message channel: data['channel'], text: scores

  when /^bot/ then
    client.message channel: data['channel'], text: "Sorry <@#{data['user']}>, what?"
  when /full sagarin ratings/i then

    rows = ['```']
    Sagarin.new.fetch.each_with_index do |team, index|
      rows << team.ljust(30) + (index + 1).to_s
    end
    rows << '```'

    client.message channel: data['channel'], text: rows.join("\n")

  when /^what sagarin is/i then

    the_team = data['text'].gsub(/^what sagarin is/i, "")

    rows = ['```']
    Sagarin.new.fetch.each_with_index do |team, index|
      if team.downcase.include? the_team.downcase.strip
        rows << team.ljust(30) + (index + 1).to_s
      end
    end
    rows << '```'
    client.message channel: data['channel'], text: rows.join("\n")

  when /bbqbot/i then
    client.typing channel: data['channel']
    client.message channel: data['channel'], text:  BbqBot.new.fetch.formatted
  end
end

client.start!
