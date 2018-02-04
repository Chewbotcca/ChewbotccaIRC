class About
  include Cinch::Plugin

  match /about/, method: :about
  match /ping/, method: :ping
  match /uptime/, method: :uptime
  match /bug (.+)/, method: :bug
  match /suggestion (.+)/, method: :bug
  match /issue (.+)/, method: :bug

  def about(m)
    m.reply 'Chewbotcca is a bot by Chewsterchew. Check it out: https://git.io/ChewbotccaIRC'
  end

  def ping(m)
    m.reply "Hello yes i am alive. ready for action. beep beep boop boop. Oh by the way that ping took #{((Time.now - m.time) * 1000.to_i).round(2)} ms."
  end

  def uptime(m)
    t = Time.now - STARTTIME
    mm, ss = t.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    days = format('%d days, ', dd) if dd != 0
    hours = format('%d hours, ', hh) if hh != 0
    mins = format('%d minutes, ', mm) if mm != 0
    secs = format('%d seconds', ss) if ss != 0
    m.reply "#{days}#{hours}#{mins}#{secs}."
  end

  def bug(m, args)
    if authenticate(m) && checkperm(m, m.user.name, 'issues')
      begin
        url = `hub issue create -m "#{args}"`
        if url == '' || url.nil?
          m.reply 'An error has occured. Check your console to see the error. Possible causes: You don\'t have hub. You don\'t have git. You don\'t have your username and password in git. The repository moved (Chewsterchew/Chewbotcca -> Chewbotcca/IRC). Or, you\'re just doing it wrong.'
        else
          m.reply "Issue created! #{url}"
        end
      end
    else
      m.reply 'You must be the bot owner to create an issue! Try making one manually: http://github.com/Chewbotcca/IRC/issues/new'
    end
  end
end
