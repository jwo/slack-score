require 'http'
require 'json'

class Insult
  def fetch
    url = 'http://quandyfactory.com/insult/json'
    data = JSON.parse Http.get(url).body
    data['insult']
  end
end
