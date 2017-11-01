class Minecraft
  include Cinch::Plugin

  match /uuid (.+)/, method: :uuid
  match /server (.+)/, method: :checkserver
  match /namemc (.+)/, method: :namemcsearch
  match /mcstatus/, method: :mcstatus
  match /namemcf/, method: :namemcfriends

  def namemcf(m, name)
    name = name.delete(' ')
    uuid = JSON.parse(RestClient.get("https://use.gameapis.net/mc/player/profile/#{name}"))['uuid_formatted']
    friends = JSON.parse(RestClient.get("https://api.namemc.com/profile/#{uuid}/friends"))
    if friends.length < 0
      m.reply "User #{name} doesn't have any friends on namemc! :("
    else
      friendcount = 1
      amount = friends.length
      while friendcount-1 < amount
        friendlist[friendcount-1] = friends[friendcount]
        friendcount += 1
        if friendlist.length > 300
          overload = "..and #{amount-friendcount} more."
          amount = friendcount
        end
      end
      m.reply "List of #{name}'s namemc friends: #{friendlist.join(', ')}.#{overload}'"
    end
  end

  def mcstatus(m)
    statusurl = JSON.parse(RestClient.get('https://status.mojang.com/check'))
    url1 = Format(:"#{statusurl[0]['minecraft.net']}", 'minecraft.net')
    url2 = Format(:"#{statusurl[1]['session.minecraft.net']}", 'session.minecraft.net')
    url3 = Format(:"#{statusurl[2]['account.mojang.com']}", 'account.mojang.com')
    url4 = Format(:"#{statusurl[3]['auth.mojang.com']}", 'auth.mojang.com')
    url5 = Format(:"#{statusurl[4]['skins.minecraft.net']}", 'skins.minecraft.net')
    url6 = Format(:"#{statusurl[5]['authserver.mojang.com']}", 'authserver.mojang.com')
    url7 = Format(:"#{statusurl[6]['sessionserver.mojang.com']}", 'sessionserver.mojang.com')
    url8 = Format(:"#{statusurl[7]['api.mojang.com']}", 'api.mojang.com')
    url9 = Format(:"#{statusurl[8]['textures.minecraft.net']}", 'textures.minecraft.net')
    url0 = Format(:"#{statusurl[9]['mojang.com']}", 'mojang.com')
    message = "#{Format(:green, 'Up')} - #{Format(:yellow, 'Shakey')} - #{Format(:red, 'Down')} : #{url1} - #{url2} - #{url3} - #{url4} - #{url5} - #{url6} - #{url7} - #{url8} - #{url9} - #{url0}"
    m.reply message
  end

  def namemcsearch(m, name)
    name = name.delete(' ')
    m.reply "NameMC Search: http://namemc.com/s/#{name}"
  end

  def uuid(m, name)
    name = name.delete(' ')
    if !JSON.parse(RestClient.get("https://use.gameapis.net/mc/player/profile/#{name}"))['error'].nil?
      m.reply "Error: #{JSON.parse(RestClient.get("https://use.gameapis.net/mc/player/profile/#{name}"))['error']} Make sure it is spelled correctly. (It is not case-sensitive)"
    else
      m.reply "The UUID of #{JSON.parse(RestClient.get("https://use.gameapis.net/mc/player/profile/#{name}"))['name']} is: #{JSON.parse(RestClient.get("https://use.gameapis.net/mc/player/profile/#{name}"))['uuid_formatted']}"
    end
  end

  def checkserver(m, serv)
    serv = serv.delete(' ')
    if serv.delete('.') == serv
      m.reply 'Not a valid address! Server IP SHOULD have dots somewhere.'
    else
      m.reply "Server Info for #{serv}:"
      sleep 0.5
      if JSON.parse(RestClient.get("https://eu.mc-api.net/v3/server/ping/#{serv}"))['online'] == true
        m.reply 'Online'
        sleep 0.5
        m.reply "Players [Online/Max]: #{JSON.parse(RestClient.get("https://eu.mc-api.net/v3/server/ping/#{serv}"))['players']['online']}/#{JSON.parse(RestClient.get("https://eu.mc-api.net/v3/server/ping/#{serv}"))['players']['max']}"
        sleep 0.5
        m.reply "Version: #{JSON.parse(RestClient.get("https://eu.mc-api.net/v3/server/ping/#{serv}"))['version']['name']}"
      else
        m.reply 'Offline'
      end
    end
  end
end
