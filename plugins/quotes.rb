class Quotes
  include Cinch::Plugin

  match /ron/, method: :getquote
  match /trbmb/, method: :trbmb
  match /acronym (.+)/, method: :acronym

  def acronym(m, acro)
    m.reply "#{acro} stands for: #{JSON.parse(RestClient.get(URI.escape("http://api.chew.pro/acronym/#{acro}")))['phrase']}"
  end

  def trbmb(m)
    m.reply JSON.parse(RestClient.get('http://api.chew.pro/trbmb'))[0]
  end

  def getquote(m)
    m.reply "\"#{JSON.parse(RestClient.get('http://ron-swanson-quotes.herokuapp.com/v2/quotes'))[0]}\" -Ron Swanson"
  end
end
