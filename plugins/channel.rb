class Channel
  include Cinch::Plugin

  listen_to :channel, method: :log_public_message, strip_colors: true
  match /resethistory/, method: :clearlog
  match /rquote/, method: :quote
  match /quote (.+)/, method: :userquote

  def userquote(m, user)
    user.delete!(' ')
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.yaml"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      exconfig = YAML.load_file('data/logs/logs.example.yaml')
      File.open(filename, 'w') { |f| f.write exconfig.to_yaml }
      m.reply 'There is no log! No log = No quotes! Try again, bucko'
      return
    end
    data = false
    data = YAML.load_file(filename) while data == false
    count = data['count']
    # Search to see if user exists.....
    # We're gonna wanna downcase the user, case sensitivity, my dudes.
    downuser = user.downcase
    # Yay let's search every message
    current = count
    while current > 1
      colon = data[current].index(':')
      userquote = data[current][0..colon - 1]
      userquote.downcase!
      if userquote.include?(downuser)
        found = true
        current = 0
      else
        found = false
        current -= 1
      end
    end
    if found == false
      m.reply "Could not find user #{user} in the log!"
      return
    end
    while userquote != user
      ichoose = rand(1..count)
      colon = data[ichoose].index(':')
      removed = data[ichoose][colon + 2..data[ichoose].length]
      userquote = data[ichoose][0..colon - 1]
    end
    m.reply "Long ago, #{user} said: \"#{removed}\""
  end

  def quote(m)
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.yaml"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      exconfig = YAML.load_file('data/logs/logs.example.yaml')
      File.open(filename, 'w') { |f| f.write exconfig.to_yaml }
      m.reply 'There is no log! No log = No quotes! Try again, bucko'
      return
    end
    data = false
    data = YAML.load_file(filename) while data == false
    count = data['count']
    ichoose = rand(1..count)
    colon = data[ichoose].index(':')
    removed = data[ichoose][colon + 2..data[ichoose].length]
    user = data[ichoose][0..colon - 1]
    m.reply "Long ago, #{user} said: \"#{removed}\""
  end

  def getrank(m, user)
    return 'owner' if m.channel.owners.join(' ').split(' ').include?(user)
    return 'admin' if m.channel.admins.join(' ').split(' ').include?(user)
    return 'op' if m.channel.ops.join(' ').split(' ').include?(user)
    return 'half-op' if m.channel.half_ops.join(' ').split(' ').include?(user)
    return 'voiced' if m.channel.voiced.join(' ').split(' ').include?(user)
    'no rank'
  end

  def clearlog(m)
    if getrank(m, m.user.name) != 'admin' && getrank(m, m.user.name) != 'owner' && getrank(m, m.user.name) != 'op'
      m.reply 'Only channel operators may reset the history!'
      return
    end
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.yaml"
    File.delete(filename)
    File.new(filename, 'w+')
    exconfig = YAML.load_file('data/logs/logs.example.yaml')
    File.open(filename, 'w') { |f| f.write exconfig.to_yaml }
    m.reply 'Consider the channel log history c l e a r e d.'
  end

  def dontlog(m)
    msg = m.params[1]
    return true if msg[0..1] == 's/'
    return true if msg[0..5] == '!quote'
    return true if msg[0..6] == '!rquote'
    false
  end

  def log_public_message(m)
    return if dontlog(m)
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.yaml"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      exconfig = YAML.load_file('data/logs/logs.example.yaml')
      File.open(filename, 'w') { |f| f.write exconfig.to_yaml }
    end
    data = YAML.load_file(filename)
    count = data['count']
    data[count + 1] = "#{m.user}: #{m.message}"
    data['count'] += 1
    File.open(filename, 'w') { |f| f.write data.to_yaml }
  end
end
