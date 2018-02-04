class Stats
  include Cinch::Plugin

  match /topspeaker/, method: :top
  match /topwords/, method: :topwords
  match /wordused (.+)/, method: :wordused
  match /messagecount/, method: :messages
  match /messages (.+)/, method: :messagesused

  def messages(m)
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.txt"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      return
    end
    log = File.readlines(filename) { |line| line.split.map(&:to_s).join }
    count = log.length
    m.reply "Overall, everyone has sent #{Format(:bold, count.to_s)} messages!"
  end

  def wordused(m, wordz)
    wordz.downcase!
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.txt"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      return
    end
    data = File.readlines(filename) { |line| line.split.map(&:to_s).join }
    users = {}.to_hash
    count = data.length
    current = count
    while current.positive?
      colon = data[current - 1].index(':')
      removed = data[current - 1][colon + 2..data[current - 1].length]
      eachword = removed.split(' ')
      currentword = 0
      while currentword < eachword.length
        word = eachword[currentword]
        word = word.tr('^A-Za-z0-9', '')
        word.downcase!
        if users[word].nil?
          users[word] = 1
        else
          users[word] += 1
        end
        currentword += 1
      end
      current -= 1
    end
    users.each do |x, y|
      if x == wordz
        m.reply "Word #{Format(:bold, wordz)} used #{Format(:bold, y.to_s)} times!"
        next
      end
    end
    m.reply "Word #{Format(:bold, wordz)} has never been used!"
  end

  def top(m)
    m.reply 'Gathering top speakers in the channel....'
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.txt"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      return
    end
    data = File.readlines(filename) { |line| line.split.map(&:to_s).join }
    count = data.length
    users = {}.to_hash
    current = count
    while current.positive?
      colon = data[current - 1].index(':')
      user = data[current - 1][13..colon - 1]
      if users[user].nil?
        users[user] = 1
      else
        users[user] += 1
      end
      current -= 1
    end
    users = users.sort.sort_by { |_x, y| y }.reverse
    sleep 1
    m.reply "1st: #{Format(:bold, users[0][0].to_s)} with #{Format(:bold, users[0][1].to_s)} messages! #{Format(:bold, "(#{(users[0][1].to_f / count * 100).round(2)}%)")}"
    if users.length > 1
      sleep 1
      m.reply "2nd: #{Format(:bold, users[1][0].to_s)} with #{Format(:bold, users[1][1].to_s)} messages! #{Format(:bold, "(#{(users[1][1].to_f / count * 100).round(2)}%)")}"
    end
    if users.length > 2
      sleep 1
      m.reply "3rd: #{Format(:bold, users[2][0].to_s)} with #{Format(:bold, users[2][1].to_s)} messages! #{Format(:bold, "(#{(users[2][1].to_f / count * 100).round(2)}%)")}"
    end
    sleep 1
    m.reply "Altogether, everyone has sent #{Format(:bold, count.to_s)} messages! Woah!"
  end

  def topwords(m)
    m.reply 'Gathering top words in the channel....'
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.txt"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      return
    end
    data = File.readlines(filename) { |line| line.split.map(&:to_s).join }
    count = data.length
    users = {}.to_hash
    current = count
    wordcount = 0
    while current.positive?
      colon = data[current - 1].index(':')
      removed = data[current - 1][colon + 2..data[current - 1].length]
      eachword = removed.split(' ')
      wordcount += eachword.length
      currentword = 0
      while currentword < eachword.length
        word = eachword[currentword]
        word = word.tr('^A-Za-z0-9', '')
        word.downcase!
        if users[word].nil?
          users[word] = 1
        else
          users[word] += 1
        end
        currentword += 1
      end
      current -= 1
    end
    users = users.sort.sort_by { |_x, y| y }.reverse
    sleep 1
    m.reply "1st: Word #{Format(:bold, users[0][0].to_s)} used #{Format(:bold, users[0][1].to_s)} times! #{Format(:bold, "(#{(users[0][1].to_f / wordcount * 100).round(2)}%)")}"
    if users.length > 1
      sleep 1
      m.reply "2nd: Word #{Format(:bold, users[1][0].to_s)} used #{Format(:bold, users[1][1].to_s)} times! #{Format(:bold, "(#{(users[1][1].to_f / wordcount * 100).round(2)}%)")}"
    end
    if users.length > 2
      sleep 1
      m.reply "3rd: Word #{Format(:bold, users[2][0].to_s)} used #{Format(:bold, users[2][1].to_s)} times! #{Format(:bold, "(#{(users[2][1].to_f / wordcount * 100).round(2)}%)")}"
    end
    sleep 1
    m.reply "Altogether, everyone has sent #{Format(:bold, wordcount.to_s)} words! Woah!"
  end

  def messagesused(m, member)
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.txt"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      return
    end
    data = File.readlines(filename) { |line| line.split.map(&:to_s).join }
    count = data.length
    users = {}.to_hash
    current = count
    while current.positive?
      colon = data[current - 1].index(':')
      user = data[current - 1][13..colon - 1]
      if users[user].nil?
        users[user] = 1
      else
        users[user] += 1
      end
      current -= 1
    end
    users = users.sort.sort_by { |_x, y| y }.reverse
    users.each do |x, y|
      if x == member
        m.reply "Member #{Format(:bold, member)} has sent #{Format(:bold, y.to_s)} messages!"
        next
      end
    end
    m.reply "Member #{Format(:bold, member)} has never sent a message!"
  end
end
