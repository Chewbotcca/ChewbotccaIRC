class Setup
  def initialize
    begin
      require 'yaml'
    rescue LoadError
      puts 'YAML not found! Is your ruby ok?'
      exit
    end
    unless File.exist?('config.yaml')
      puts 'No config file! Creating one now..'
      File.new('config.yaml', 'w+')
      exconfig = YAML.load_file('config.example.yaml')
      File.open('config.yaml', 'w') { |f| f.write exconfig.to_yaml }
    end
    @config = YAML.load_file('config.yaml')
    exit if @config == false
  end

  def welcome(skipwelcome = true)
    unless skipwelcome
      puts 'Welcome to Chewbotcca IRC bot setup'
      puts 'This really simple GUI will guide you in setting up the bot by yourself!'
      puts 'Press enter to get started'
      gets
    end
    puts 'What would you like to Configure (type number then press enter)'
    puts '[1] - Configure the bot'
    puts '[2] - Set up staff members'
    puts '[3] - Exit!'
    input = gets.chomp

    config if input == '1'
    staffauth if input == '2'
    exit
  end

  def config
    puts 'Alright! Config time.'

    puts 'What would you like to configure?'
    puts '[1] - Bot information (REQUIRED)'
    puts '[2] - Connection information (REQUIRED)'
    puts '[3] - API Keys'
    puts '[4] - Main Menu'
    input = gets.chomp

    configure('bot') if input == '1'
    configure('server') if input == '2'
    configure('api') if input == '3'
    welcome
  end

  def configure(section)
    if section == 'bot'
      puts 'Pick a nickname for the bot - REQUIRED'
      @config['nickname'] = gets.chomp

      puts 'What channels should the bot join on startup? this must be comma seperated with #s before the names. - Optional'
      puts 'Hint! You can always invite the bot to your channel and it will join!'
      @config['channels'] = gets.chomp

      puts "What should be the bot's realname? This is shown in a whois. - Optional"
      @config['realname'] = gets.chomp

      puts 'What should be the bot\'s USERNAME? (this is what\'s shown before the @ in a hostname. e.g. chew!THIS@blah) - Optional'
      @config['username'] = gets.chomp

      puts 'NickServ Password - Optional'
      puts 'Not registered? The bot has a built in NickServ registration process!'
      @config['nickservpass'] = gets.chomp

      puts 'Bot Prefix - Optional'
      puts 'What should be the bot\'s prefix? Leave empty for the default, "!"'
      @config['prefix'] = gets.chomp

      puts 'Bot Prefix Location - Optional'
      puts 'Should commands HAVE to be at the beginning of messages, or can they be anywhere? (true/false)'
      input = gets.chomp
      @config['prefixstart'] = true?(input)

      puts 'It turns out you\'re done configuring bot settings!'
      save
      config
    end

    if section == 'server'
      puts 'Enter the server address (hostname, IP, whatever, NO PORT yet) - REQUIRED'
      @config['server'] = gets.chomp

      puts 'Enter the server port, if you don\'t know, use 6667 - REQUIRED'
      @config['port'] = gets.chomp

      puts 'Connect using SSL? (true/false)'
      input = gets.chomp
      @config['ssl'] = true?(input)

      puts 'Done configuring server connection information!'
      save
      config
    end

    if section == 'api'
      puts 'Wordnik API key. Very optional and only needed for !define !antonym and !synonym'
      @config['wordnik'] = gets.chomp

      puts 'Google API key. Very optional and only needed for !youtube and such'
      @config['google'] = gets.chomp

      puts 'Cleverbot API key.'
      @config['cleverbot'] = gets.chomp

      puts 'Spotify Client ID (application).'
      @config['spotifyclientid'] = gets.chomp

      puts 'Spotify Client Secret (application).'
      @config['spotifysecret'] = gets.chomp

      puts 'Last.fm API key.'
      @config['lastfm'] = gets.chomp

      puts 'It turns out you\'re done configuring API settings!'
      save
      config
    end
  end

  def save
    File.open('config.yaml', 'w') { |f| f.write @config.to_yaml }
  rescue => e
    puts 'uh oh, there was an error saving. Report the following error to Chew on github'
    puts e
  end

  def staffauth
    puts 'First, we must decide how you want to authenticate'

    puts 'What authentication method do you want?'
    puts '[1] - host - Match according to hostname. Not recommended for web-client users'
    puts '[2] - username - Match according to username. Recommended for IRCCloud users! Not recommeneded for normal users.'
    puts '[3] - nickname - Match according to nickname. Not recommeneded as people can literally change their nick if it\'t not taken'
    puts '[4] - userhost - Use options 1 and 2, match according to host and username.'
    puts '[5] - all - Use options 1, 2, and 3, match according to all 3 options.'
    puts '[6] - Main Menu'
    input = gets.chomp

    staff('host') if input == '1'
    staff('username') if input == '2'
    staff('nickname') if input == '3'
    staff('userhost') if input == '4'
    staff('all') if input == '5'
    config
  end

  def staff(section)
    puts 'What is this staff members IRC nickname?'
    name = gets.chomp
    stafffile = "data/staff/#{name}.yaml"
    if File.exist?(stafffile)
      puts 'There is already a staff member with that name! Overwrite their data? (y/n)'
      if gets.chomp == 'n'
        puts 'Sending you back to authentication method page'
        staffauth
      end
    end
    File.new(stafffile, 'w+')
    exconfig = YAML.load_file('data/staff/staff.example.yaml')
    File.open(stafffile, 'w') { |f| f.write exconfig.to_yaml }
    staffdata = YAML.load_file(stafffile)
    if section == 'host'
      puts 'What is the staff member\'s hostname?'
      staffdata['host'] = gets.chomp
    end
    if section == 'username'
      puts 'What is the staff member\'s username?'
      staffdata['user'] = gets.chomp
    end
    if section == 'userhost'
      puts 'What is the staff member\'s hostname?'
      staffdata['host'] = gets.chomp
      puts 'What is the staff member\'s username?'
      staffdata['user'] = gets.chomp
    end
    if section == 'all'
      puts 'What is the staff member\'s hostname?'
      staffdata['host'] = gets.chomp
      puts 'What is the staff member\'s username?'
      staffdata['user'] = gets.chomp
    end
    puts 'Good! The rank and stuff is set up! Let\'s get to the perms'
    puts 'Answer all with "true" or "false"'
    puts 'Should they have access to !restart and !update?'
    input = gets.chomp
    staffdata['restart'] = true?(input)
    puts 'Should they have access modify channel perms, regardless of rank on the channel?'
    input = gets.chomp
    staffdata['fullchannelperms'] = true?(input)
    puts 'Should they have access to make the bot leave and join chans?'
    input = gets.chomp
    staffdata['botchans'] = true?(input)
    puts 'Should they have access to !eval?'
    input = gets.chomp
    staffdata['eval'] = true?(input)
    puts 'Should they have access to !die?'
    input = gets.chomp
    staffdata['die'] = true?(input)
    puts 'Should they have access to change the config (!config [option])?'
    input = gets.chomp
    staffdata['changeconfig'] = true?(input)
    puts 'Should they have access to change staff permissions (!permissions)?'
    input = gets.chomp
    staffdata['changepermissions'] = true?(input)
    staffdata['authtype'] = section
    staffdata['nick'] = name
    File.open(stafffile, 'w') { |f| f.write staffdata.to_yaml }
    puts "Staff Member #{name} completely set up! Bombs away!"
  end

  def true?(obj)
    obj.to_s == 'true'
  end
end

jerry = Setup.new
jerry.welcome(false)
