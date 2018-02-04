class Replace
  include Cinch::Plugin

  match /(.+)/, method: :replace, prefix: /s\//
  match /(.+)/, method: :replace, prefix: /S\//

  def replace(m, message)
    return if m.params[1][0..1] != 's/' && m.params[1][0..1] != 'S/'
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/logs/#{channel}.txt"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      return
    end
    log = File.readlines(filename) { |line| line.split.map(&:to_s).join }
    count = log.length
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
    while current.positive?
      colon = log[current - 1].index(':')
      removed = log[current - 1][colon + 2..log[current - 1].length]
      user = log[current - 1][0..colon - 1]
      if removed.include?(find)
        useme = removed
        current = -1
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
      replaced = replaced.delete("\n")
      user = user[13..user.length]
      m.reply "Correction, #{user}. \"#{replaced}\""
      File.open(filename, 'a+') { |f| f.puts("[#{Time.now.to_i}] #{user}: #{useme.gsub(find, replace)}") }
    end
  end
end
