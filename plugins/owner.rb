class Owner
  include Cinch::Plugin

  match /join (.+)/, method: :join
  match /part (.+)/, method: :part
  match /eval (.+)/, method: :execute
  match /die/, method: :die
  match /api (.+) (.+)/, method: :api
  match /uperms/, method: :perms
  match /config (.+) (.+)/, method: :config
  match /permissions (.+) (.+) (.+)/, method: :permissions

  def config(m, option, setting)
    return unless authenticate(m) && checkperm(m, m.user.name, 'changeconfig')
    CONFIG[option] = setting
    File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
    m.reply "#{option} successfully set to: `#{setting}`!"
  end

  def permissions(m, nick, perm, setting)
    return unless authenticate(m) && checkperm(m, m.user.name, 'changepermissions')
    file = "data/staff/#{nick}.yaml"
    m.reply "That staff member doesn't exist!" unless File.exist?(file)
    m.reply 'Invalid permission!' unless %w[restart fullchannelperms botchans eval die changeconfig changepermissions].include? perm
    data = YAML.load_file(file)
    setting = true?(setting)
    data[perm] = setting
    File.open(file, 'w') { |f| f.write data.to_yaml }
    m.reply "Permission `#{perm}` successfully set to `#{setting}` for Staff member #{nick}!"
  end

  def true?(obj)
    obj.to_s == 'true'
  end

  def perms(m)
    stafffile = "data/staff/#{m.user.name}.yaml"
    m.reply "You aren't a staff member! You have no perms!" unless File.exist?(stafffile)
    staffdata = YAML.load_file(stafffile)
    perms = []
    perms += ['restart'] if staffdata['restart'] == true
    perms += ['fullchannelperms'] if staffdata['fullchannelperms'] == true
    perms += ['botchans'] if staffdata['botchans'] == true
    perms += ['eval'] if staffdata['eval'] == true
    perms += ['die'] if staffdata['die'] == true
    perms += ['changeconfig'] if staffdata['changeconfig'] == true
    perms += ['changepermissions'] if staffdata['changepermissions'] == true
    m.reply "Your perms are: #{perms.join(', ')}"
  end

  def api(m, service, key)
    return unless authenticate(m) && checkperm(m, m.user.name, 'changeconfig')
    m.reply 'Invalid API service!' unless %w[wordnik google cleverbot spotifyclientid spotifysecret lastfm].include? service
    CONFIG[service] = key
    File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
    m.reply "#{service} API key set to: `#{key}`!"
  end

  def die(m)
    if authenticate(m) && checkperm(m, m.user.name, 'die')
      m.reply 'Shutting down the bot peacefully...'
      sleep 1
      eval exit
    else
      m.reply "You can't kill me because you're not allowed to! Muhaha! I live on!"
    end
  end

  def execute(m, code)
    if authenticate(m) && checkperm(m, m.user.name, 'eval')
      begin
        m.reply eval code
      rescue => e
        evalerrors = [
          'Well, excuse me, mr nobrain, cant even eval correctly smh.',
          "You can't eval? Why are you running a bot!",
          'Evaluation error! Please consult your handbook (as in how to properly ruby)',
          'The real error here is your lack of ruby knowledge.',
          'Has halloween come early this year? because your lack of ability to eval is pretty spooky.'
        ]
        m.reply "#{evalerrors.sample} THE ERROR: ```#{e}```"
      end
    else
      m.reply 'An error was thrown (similar to a baseball). It crashed through your house window and had a message written on it. It says: "You do not have permission to evaluate!" Now you have to fix your window.'
    end
  end

  def part(m, part)
    if authenticate(m) && checkperm(m, m.user.name, 'botchans')
      channels = CONFIG['channels'].split(',')
      channels -= [part]
      CONFIG['channels'] = channels.join(',')
      File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
      Channel(part).part
      m.reply 'Left the channel successfully!'
    else
      m.reply 'You are not permitted to do this action!'
    end
  end

  def join(m, join)
    if authenticate(m) && checkperm(m, m.user.name, 'botchans')
      channels = CONFIG['channels'].split(',')
      channels += [join]
      CONFIG['channels'] = channels.join(',')
      File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
      Channel(join).join
      m.reply 'Joined the channel successfully!'
    else
      m.reply 'You are not permitted to do this action!'
    end
  end
end
