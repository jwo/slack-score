
require 'bundler'
Bundler.require
Dotenv.load

require './slack-score-api'
scores = SlackScore.new.formatted

puts scores
