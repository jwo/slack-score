require './slack-score-api'
require './schedule'

# puts SlackScore.new.formatted_rankings

puts Schedule.new.when?("texas")