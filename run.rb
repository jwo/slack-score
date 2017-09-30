require './slack-score-api'
require './schedule'

puts SlackScore.new.formatted_schedule

# puts Schedule.new.when?(["Georgia"])
