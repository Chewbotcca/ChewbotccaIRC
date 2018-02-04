class Channel
  include Cinch::Plugin

  listen_to :channel, method: :log_public_message, strip_colors: true
  match /resethistory/, method: :clearlog
  match /rquote/, method: :quote
  match /quote (.+)/, method: :userquote
  match /channel (.+) (.+)/, method: :channelconfig

  def channelconfig(m, option, setting)
    if getrank(m, m.user.name) > 1
      channel = m.channel.to_s[1..m.channel.to_s.length]
      filename = "data/channels/#{channel}.yaml"
      unless File.exist?(filename)
        File.new(filename, 'w+')
        exconfig = YAML.load_file('data/channels/channel.example.yaml')
        exconfig['name'] = channel
        File.open(filename, 'w') { |f| f.write exconfig.to_yaml }
      end
      data = false
      data = YAML.load_file(filename) while data == false
    end
    case option
    when 'youtubelinks'
      if getrank(m, m.user.name) < 2
        m.reply 'Only half-ops and above may modify the config option `youtubelinks`!'
        return
      end
      data['youtubelinks'] = setting
      File.open(filename, 'w') { |f| f.write data.to_yaml }
      m.reply "👍 Option `youtubelinks` set to `#{setting}`."
      return
    end
  end

  def userquote(m, user)
    user.delete!(' ')
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.txt"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      m.reply 'There is no log! No log = No quotes! Try again, bucko'
      return
    end
    log = File.readlines(filename) { |line| line.split.map(&:to_s).join }
    count = log.length
    # Search to see if user exists.....
    # We're gonna wanna downcase the user, case sensitivity, my dudes.
    downuser = user.downcase
    current = count
    while current.positive?
      colon = log[current - 1].index(':')
      userquote = log[current - 1][0..colon - 1]
      userquote.downcase!
      if userquote.include?(downuser)
        found = true
        current = -1
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
      ichoose = rand(0..count - 1)
      colon = log[ichoose].index(':')
      removed = log[ichoose][colon + 2..log[ichoose].length].chomp
      userquote = log[ichoose][13..colon - 1]
    end
    time = log[ichoose][1..10]
    t = Time.now.to_i - time.to_i
    mm, ss = t.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    days = format('%d days, ', dd) if dd != 0
    hours = format('%d hours, ', hh) if hh != 0
    mins = format('%d minutes, ', mm) if mm != 0
    secs = format('%d seconds', ss) if ss != 0
    m.reply "#{days}#{hours}#{mins}#{secs} ago, #{user} said: \"#{removed}\""
  end

  def quote(m)
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.txt"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      m.reply 'There is no log! No log = No quotes! Try again, bucko'
      return
    end
    log = File.readlines(filename) { |line| line.split.map(&:to_s).join }
    count = log.length
    ichoose = rand(0..count - 1)
    colon = log[ichoose].index(':')
    removed = log[ichoose][colon + 2..log[ichoose].length].chomp
    user = log[ichoose][13..colon - 1]
    time = log[ichoose][1..10]
    t = Time.now.to_i - time.to_i
    mm, ss = t.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    days = format('%d days, ', dd) if dd != 0
    hours = format('%d hours, ', hh) if hh != 0
    mins = format('%d minutes, ', mm) if mm != 0
    secs = format('%d seconds', ss) if ss != 0
    m.reply "#{days}#{hours}#{mins}#{secs} ago, #{user} said: \"#{removed}\""
  end

  def getrank(m, user)
    return 5 if authenticate(m) && checkperm(m, m.user.name, 'fullchannelperms')
    return 5 if m.channel.owners.join(' ').split(' ').include?(user)
    return 4 if m.channel.admins.join(' ').split(' ').include?(user)
    return 3 if m.channel.ops.join(' ').split(' ').include?(user)
    return 2 if m.channel.half_ops.join(' ').split(' ').include?(user)
    return 1 if m.channel.voiced.join(' ').split(' ').include?(user)
    0
  end

  def clearlog(m)
    return if Time.now - STARTTIME < 10
    if getrank(m, m.user.name) < 3
      m.reply 'Only channel operators may reset the history!'
      return
    end
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.txt"
    File.open(filename, 'w') { |file| file.truncate(0) }
    m.reply 'Consider the channel log history c l e a r e d.'
  end

  def dontlog(m)
    msg = m.params[1]
    return true if Time.now - STARTTIME < 10
    return true if msg[0..CONFIG['prefix'].length - 1] == CONFIG['prefix']
    return true if msg[0..1] == 's/'
    return true if msg[0..1] == 'S/'
    false
  end

  def log_public_message(m)
    return if dontlog(m)
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.txt"
    File.new(filename, 'w+') unless File.exist?(filename)
    author = if m.user.name == '' || m.user.name.nil?
               'Unknown'
             else
               m.user.name
             end
    File.open(filename, 'a+') { |f| f.puts("[#{Time.now.to_i}] #{author}: #{m.message}") }
  end
end
