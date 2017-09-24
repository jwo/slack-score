require './slack-score-api'
require './schedule'

# puts SlackScore.new.schedule

puts Schedule.new.when?("Texas")