# Chewbotcca IRC Bot

# Require Gems needed to run programs and plugins
require './requiregems.rb'

# Load config from file
begin
  CONFIG = YAML.load_file('config.yaml')
rescue
  puts 'Config file not found, this is fatal, running setup.'
  `ruby setup.rb`
  exit
end

# Require each plugin
Dir["#{File.dirname(__FILE__)}/plugins/*.rb"].each { |file| require file }

# Set up uptime.
STARTTIME = Time.now

# Pre-Config
botnick = if CONFIG['nickname'] == '' || CONFIG['nickname'].nil?
            puts 'The bot doesn\'t have a nickname! Please set one'
            exit
          else
            CONFIG['nickname'].to_s
          end

botserver = if CONFIG['server'] == '' || CONFIG['server'].nil?
              puts 'You did not configure a server for the bot to connect to. Please set one!'
              exit
            else
              CONFIG['server'].to_s
            end

botport = if CONFIG['port'].nil?
            '6667'
          else
            CONFIG['port']
          end

botuser = if CONFIG['username'].nil? || CONFIG['username'] == ''
            CONFIG['nickname']
          else
            CONFIG['username']
          end

botrealname = if CONFIG['realname'].nil? || CONFIG['realname'] == ''
                'Chewbotcca IRC Bot - https://git.io/ChewbotccaIRC'
              else
                "#{CONFIG['realname']} - https://git.io/ChewbotccaIRC"
              end

botssl = if CONFIG['ssl'].nil? || CONFIG['ssl'] == '' || CONFIG['ssl'] == 'false'
           nil
         else
           'true'
         end

botserverpass = if CONFIG['serverpass'].nil? || CONFIG['serverpass'] == ''
                  nil
                else
                  CONFIG['serverpass']
                end

botprefix = if CONFIG['prefix'].nil? || CONFIG['prefix'] == ''
              /!/
            else
              Regexp.new CONFIG['prefix']
            end

# Configure the Bot
bot = Cinch::Bot.new do
  configure do |c|
    # Bot Settings, Taken from pre-config
    c.nick = botnick
    c.server = botserver
    c.channels = [CONFIG['channels']]
    c.port = botport
    c.user = botuser
    c.realname = botrealname
    c.messages_per_second = 20
    c.ssl.use = botssl
    c.password = botserverpass
    c.plugins.prefix = botprefix

    # Load modules.
    c.plugins.plugins = [Misc, Minecraft, Owner, Restart, RandomCat, MemeDB, Quotes, ModifyConfig, NickServ, InviteToJoin, Bitcoin, About, English, Emoji, Food, Grammar, Formatting, BaseS4, GitHub, Google, Cleverbot, Channel, Language, Replace, Streams, Music]
  end
end
# START THE BOT
bot.start
