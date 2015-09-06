require './sagarin'

Sagarin.new.fetch.each_with_index do |team, index|
  puts team.ljust(40) + (index + 1).to_s
end
