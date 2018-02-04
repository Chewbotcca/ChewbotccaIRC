class Language
  include Cinch::Plugin

  match /piglatin (.+)/, method: :piglatin
  match /leet (.+)/, method: :leet

  def leet(m, args)
    m.reply JSON.parse(RestClient.post('http://api.funtranslations.com/translate/leetspeak.json', { 'text' => args }.to_json, content_type: :json))['contents']['translated']
  end

  def piglatin(m, args)
    m.reply JSON.parse(RestClient.post('http://api.funtranslations.com/translate/piglatin.json', { 'text' => args }.to_json, content_type: :json))['contents']['translated']
  end
end
