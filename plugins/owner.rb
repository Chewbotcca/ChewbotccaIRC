class Owner
  include Cinch::Plugin

  match /join (.+)/, method: :join
  match /part (.+)/, method: :part
  match /eval (.+)/, method: :execute
  match /die/, method: :die

  def die(m)
    if m.user.host == CONFIG['ownerhost']
      m.reply 'Shutting down the bot peacefully...'
      exit
    else
      m.reply "You can't kill the bot! (If you are the owner of the bot, you did not configure properly! Otherwise, stop trying to KILL the bot!)"
    end
  end

  def execute(m, code)
    if m.user.host == CONFIG['ownerhost']
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
    if m.user.host == CONFIG['ownerhost']
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
    if m.user.host == CONFIG['ownerhost']
      CONFIG['channels'] = "#{CONFIG['channels']},#{join}"
      File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
      Channel(join).join
      m.reply 'Joined the channel successfully!'
    else
      m.reply 'You are not permitted to do this action!'
    end
  end
end
