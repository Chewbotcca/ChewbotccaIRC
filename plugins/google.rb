class Google
  include Cinch::Plugin

  match /video (.+)/, method: :youtube
  match /googl (.+)/, method: :googl
  match /youtube (.+)/, method: :searchyt
  match %r{(https?://.*?)(?:\s|$|,|\.\s|\.$)}, use_prefix: false, method: :youtube
  match /youtime (.+)/, method: :duration
  match /lmgtfy (.+)/, method: :letmegooglethat
  match /lmbtfy (.+)/, method: :letmebingthat
  match /lmddgtfy (.+)/, method: :letmeddgthat

  def letmegooglethat(m, search)
    m.reply "LMGTFY Link for #{search}: #{URI.escape("http://lmgtfy.com/?q=#{search}")}"
  end

  def letmebingthat(m, search)
    m.reply "LMBTFY Link for #{search}: #{URI.escape("http://lmgtfy.com/?s=b&q=#{search}")}"
  end

  def letmeddgthat(m, search)
    m.reply "LMDDGTFY Link for #{search}: #{URI.escape("http://lmgtfy.com/?s=d&q=#{search}")}"
  end

  def duration(m, search)
    url = URI.escape("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=1&q=#{search}&key=#{CONFIG['google']}")
    id = JSON.parse(RestClient.get(url))['items'][0]['id']['videoId']
    begin
      url = JSON.parse(RestClient.get("https://www.googleapis.com/youtube/v3/videos?id=#{id}&key=#{CONFIG['google']}&part=snippet,contentDetails,statistics"))
    rescue
      m.reply 'This command requires a Google API key!'
      return
    end
    length = url['items'][0]['contentDetails']['duration']
    length = length[2..length.length]
    length.downcase!
    m.reply "Length of YouTube video is: #{Format(:bold, length.to_s)}. (URL: http://youtu.be/#{id})"
  end

  def searchyt(m, search)
    url = URI.escape("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=1&q=#{search}&key=#{CONFIG['google']}")
    id = JSON.parse(RestClient.get(url))['items'][0]['id']['videoId']
    video = "http://youtu.be/#{id}"
    youtube(m, video, true, true)
  rescue
    return
  end

  def googl(m, url)
    m.reply JSON.parse(RestClient.post("https://www.googleapis.com/urlshortener/v1/url?key=#{CONFIG['google']}", { 'longUrl' => url }.to_json, content_type: :json))['id']
  rescue
    m.reply 'This command requires a Google API key!'
    return
  end

  def youtube(m, url, provideurl = false, bypassconfig = false)
    channel = m.channel.to_s[1..m.channel.to_s.length]
    filename = "data/channels/#{channel}.yaml"
    unless File.exist?(filename)
      File.new(filename, 'w+')
      exconfig = YAML.load_file('data/channels/channel.example.yaml')
      exconfig['name'] = channel
      File.open(filename, 'w') { |f| f.write exconfig.to_yaml }
    end
    data = false
    data = YAML.load_file(filename) while data == false
    return if data['youtubelinks'] == 'false' && bypassconfig == false
    begin
      givenurl = url
      url = url.split(/[\/,&,?,=]/)
      case url[2]
      when 'www.youtube.com'
        id = url[5]
      when 'youtu.be'
        id = url[3]
      else
        return
      end
      url = JSON.parse(RestClient.get("https://www.googleapis.com/youtube/v3/videos?id=#{id}&key=#{CONFIG['google']}&part=snippet,contentDetails,statistics"))
    rescue => e
      if CONFIG['google'] == '' || CONFIG['google'].nil?
        m.reply 'This command requires a Google API key!'
      else
        m.reply "There was an error grabbing YouTube link information, don't worry! You did nothing wrong, please report the following error to Chew on GitHub: ```#{e.to_s.delete("\n")}```."
      end
      return
    end
    stats = url['items'][0]['statistics']
    info = url['items'][0]['snippet']
    length = url['items'][0]['contentDetails']['duration']
    length = length[2..length.length]
    length.downcase!
    views = stats['viewCount'].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    likes = stats['likeCount'].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    dislike = stats['dislikeCount'].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    intdislike = dislike.delete(',').to_i
    intlike = likes.delete(',').to_i
    upload = info['publishedAt'][0..9]
    upload = upload.split('-')
    totallikes = intdislike + intlike
    percent = (intlike / totallikes.to_f * 100).round(2)
    case upload[1]
    when '01'
      month = 'January'
    when '02'
      month = 'Feburary'
    when '03'
      month = 'March'
    when '04'
      month = 'April'
    when '05'
      month = 'May'
    when '06'
      month = 'June'
    when '07'
      month = 'July'
    when '08'
      month = 'August'
    when '09'
      month = 'September'
    when '10'
      month = 'October'
    when '11'
      month = 'November'
    when '12'
      month = 'December'
    end
    urlpls = if provideurl
               " #{givenurl}"
             else
               '.'
             end
    m.reply "#{Format(:bold, (info['title']).to_s)} by #{Format(:bold, (info['channelTitle']).to_s)} | length: #{Format(:bold, length.to_s)} | #{Format(:bold, views.to_s)} views | #{Format(:bold, likes.to_s)} likes - #{Format(:bold, dislike.to_s)} dislikes (#{Format(:bold, percent.to_s)}%) | Uploaded on #{Format(:bold, "#{month} #{upload[2]}, #{upload[0]}#{urlpls}")}"
  end
end
