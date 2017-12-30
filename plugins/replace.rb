class Replace
  include Cinch::Plugin

  match /(.+)/, method: :replace, prefix: /s\//
  match /(.+)/, method: :replace, prefix: /S\//
  
  def replace(m, message)
    return if m.params[1][0..1] != 's/'|| m.params[1][0..1] != 'S/'
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.yaml"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      exconfig = YAML.load_file('data/logs/logs.example.yaml')
      File.open(filename, 'w') { |f| f.write exconfig.to_yaml }
      m.reply 'HEY GUESS WHOS RETURNNING'
      return
    end
    data = YAML.load_file(filename)
    count = data['count']
    return if message.split('/').length > 2
    return if message.split('/').empty?
    split = message.split('/')
    find = split[0]
    replace = if message.split('/').length == 1
                ''
              else
                split[1]
              end
    # Yay let's search every message
    current = count
    useme = ''
    while current > 1
      colon = data[current].index(':')
      removed = data[current][colon + 2..data[current].length]
      user = data[current][0..colon - 1]
      if removed.include?(find)
        useme = removed
        current = 0
      else
        current -= 1
      end
    end
    if useme == ''
      m.reply "Could not find phrase #{Format(:bold, find)} in the logs!"
      return
    else
      replaced = if replace == ''
                   useme.delete(find)
                 else
                   useme.gsub(find, Format(:bold, replace))
                 end
      replaced = replaced[0..400]
      m.reply "Correction, #{user}. \"#{replaced}\""
      data[count + 1] = "#{user}: #{useme.gsub(find, replace)}"
      data['count'] += 1
      File.open(filename, 'w') { |f| f.write data.to_yaml }
    end
  end
end
