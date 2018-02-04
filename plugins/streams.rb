class Streams
  include Cinch::Plugin

  match /mixer (.+)/, method: :mixer

  def mixer(m, user)
    user = user.delete(' ')
    begin
      parse = JSON.parse(RestClient.get("https://mixer.com/api/v1/channels/#{user}"))
    rescue
      m.reply 'User not found!'
      return
    end
    name = parse['token']
    online = if parse['online']
               Format(:green, 'Currently Streaming!')
             else
               Format(:red, 'Currently Offline')
             end
    followers = parse['numFollowers'].to_s
    m.reply "Info for Mixer user #{Format(:bold, name)} | #{Format(:bold, online)} | Followers: #{Format(:bold, followers)} | Stream Title: #{Format(:bold, parse['name'])} | Total Views: #{Format(:bold, parse['viewersTotal'].to_s)} | URL: http://mixer.com/#{name}"
  end
end
