class Restart
  include Cinch::Plugin

  match /restart/, method: :restart
  match /update/, method: :update
  match /updates/, method: :updates

  def restart(m)
    return if Time.now - STARTTIME < 10
    unless authenticate(m) && checkperm(m, m.user.name, 'restart')
      m.reply "You can't update! (If you are the owner of the bot, you did not configure properly! Otherwise, stop trying to update the bot!)"
      return
    end
    m.reply 'Restarting the bot without updating...'
    sleep 1
    if CONFIG['bundler'] == 'true' || CONFIG['bundler'] == true
      exec('bundle exec ruby bot.rb')
    else
      exec('ruby bot.rb')
    end
  end

  def update(m)
    return if m.params[1][CONFIG['prefix'].length..CONFIG['prefix'].length + 7] == 'updates'
    return if Time.now - STARTTIME < 10
    unless authenticate(m) && checkperm(m, m.user.name, 'restart')
      m.reply "You can't update! (If you are the owner of the bot, you did not configure properly! Otherwise, stop trying to update the bot!)"
      return
    end
    m.reply 'Restarting and Updating!'
    sleep 1
    `git pull`
    if CONFIG['bundler'] == 'true' || CONFIG['bundler'] == true
      exec('bundle exec ruby bot.rb')
    else
      exec('ruby bot.rb')
    end
  end

  def updates(m)
    unless authenticate(m) && checkperm(m, m.user.name, 'restart')
      m.reply 'You are not allowed to check for updates!'
      return
    end
    m.reply 'Checking for updates...'
    response = `git fetch`
    if response == ''
      m.reply 'No new updates available.'
    else
      m.reply "New updates found! Run `#{CONFIG['prefix']}update` to update"
    end
  end
end
