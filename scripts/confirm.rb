# Chewbotcca IRC Bot

# Require Gems needed to run programs and plugins
require './requiregems.rb'

# Load config from file
begin
  CONFIG = YAML.load_file('config.yaml')
rescue StandardError
  puts 'Config file not found, this is fatal, please configure the bot.'
  exit
end

NICKNAME = (0...8).map { rand(65..90).chr }.join

class Confirm
  include Cinch::Plugin

  listen_to :connect, method: :identify
  match NICKNAME.to_s, method: :whodidthis
  match /exit/, method: :that

  def identify(_m)
    User(CONFIG['ownernick']).send('Hello! It is me, Chewbotcca! Please respond with my nickname to confirm your identity, othwerwise, type `exit`')
  end

  def whodidthis(m)
    if m.user.nick == CONFIG['ownernick']
      CONFIG['ownerhost'] = m.user.host
      File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
      exit
    end
  end

  def that(m)
    exit if m.user.nick == CONFIG['ownernick']
  end
end

# Configure the Bot
bot = Cinch::Bot.new do
  configure do |c|
    # Bot Settings, Taken from Config.yaml
    c.nick = NICKNAME
    c.server = CONFIG['server']

    c.plugins.prefix = /^/

    # Load modules.
    c.plugins.plugins = [Confirm]
  end
end
# START THE BOT
bot.start
