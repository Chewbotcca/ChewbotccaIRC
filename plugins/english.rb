class English
  include Cinch::Plugin

  match /define (.+)/, method: :define
  match /randomword/, method: :randomword
  match /wordrandom/, method: :randomword
  match /synonym (.+)/, method: :synonym
  match /antonym (.+)/, method: :antonym
  match /urban (.+)/, method: :urban

  def urban(m, word)
    parse = JSON.parse(RestClient.get("http://api.urbandictionary.com/v0/define?term=#{word}"))
    if parse['result_type'].to_s == 'no_results'
      m.reply "No results found for term #{Format(:bold, word)}!"
      return
    end
    info = parse['list'][0]
    definition = info['definition'].to_s
    definition = definition.delete("\n")
    if definition.length > 200
      definition = definition[0..200]
      definition = "#{definition}..."
    end
    up = info['thumbs_up'].to_s
    author = info['author'].to_s
    example = info['example'].to_s
    down = info['thumbs_down'].to_s
    total = up.to_i + down.to_i
    ratio = (up.to_f / total.to_f * 100).round(2).to_s
    word = info['word'].to_s
    url = info['permalink']
    m.reply "Urban Dictionary defintion for #{Format(:bold, word)}: #{Format(:bold, definition)} | Author: #{Format(:bold, author.to_s)} | #{Format(:bold, up)} 👍 - #{Format(:bold, down)} 👎 (#{Format(:bold, ratio)}%) | Example: #{Format(:bold, example)} | URL: #{url}"
  end

  def checkapi
    if CONFIG['wordnik'] == '' || CONFIG['wordnik'].nil?
      'false'
    else
      'true'
    end
  end

  def antonym(m, word)
    unless checkapi == 'true'
      m.reply 'This command requires an API key from wordnik'
      return
    end
    grabbedword = JSON.parse(RestClient.get("http://api.wordnik.com/v4/word.json/#{word}/relatedWords?useCanonical=false&relationshipTypes=antonym&limitPerRelationshipType=10&api_key=#{CONFIG['wordnik']}"))
    begin
      m.reply "Antonym(s) for #{word}: #{grabbedword[0]['words'].join(', ')}"
    rescue
      m.reply 'Word not found (or there were no Antonyms) Check your local spell-checker!'
    end
  end

  def synonym(m, word)
    unless checkapi == 'true'
      m.reply 'This command requires an API key from wordnik'
      return
    end
    grabbedword = JSON.parse(RestClient.get("http://api.wordnik.com/v4/word.json/#{word}/relatedWords?useCanonical=false&relationshipTypes=synonym&limitPerRelationshipType=10&api_key=#{CONFIG['wordnik']}"))
    begin
      m.reply "Synonym(s) for #{word}: #{grabbedword[0]['words'].join(', ')}"
    rescue
      m.reply 'Word not found (or there were no Synonyms) Check your local spell-checker!'
    end
  end

  def randomword(m)
    unless checkapi == 'true'
      m.reply 'This command requires an API key from wordnik'
      return
    end
    m.reply "Random Word: #{JSON.parse(RestClient.get("http://api.wordnik.com:80/v4/words.json/randomWord?hasDictionaryDef=true&minCorpusCount=0&maxCorpusCount=-1&minDictionaryCount=1&maxDictionaryCount=-1&minLength=5&maxLength=-1&api_key=#{CONFIG['wordnik']}"))['word']}"
  end

  def define(m, word)
    unless checkapi == 'true'
      m.reply 'This command requires an API key from wordnik'
      return
    end
    grabbedword = JSON.parse(RestClient.get("http://api.wordnik.com/v4/word.json/#{word}/definitions?limit=1&includeRelated=true&useCanonical=false&includeTags=false&api_key=#{CONFIG['wordnik']}"))
    begin
      m.reply "Defintion for #{word}: #{grabbedword[0]['partOfSpeech']}. #{grabbedword[0]['text']}"
    rescue
      m.reply 'Word not found! Check your local spell-checker!'
    end
  end
end
