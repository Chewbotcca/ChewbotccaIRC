class MemeDB
  include Cinch::Plugin

  match /memedb (.+)/, method: :findthatmeme

  def findthatmeme(m, meme)
    meme.downcase!
    case meme
    when 'rickroll'
      m.reply 'http://chewbotcca.co/memedb/rickroll.gif'
    when 'vegans'
      m.reply 'http://chewbotcca.co/memedb/vegans.png'
    when 'spotad'
      m.reply 'http://chewbotcca.co/memedb/spotad.jpg'
    when 'petpet'
      m.reply 'http://chewbotcca.co/memedb/petpet.jpg'
    when 'nicememe'
      m.reply 'http://chewbotcca.co/memedb/nicememe.gif'
    when 'paycheck'
      m.reply 'http://chewbotcca.co/memedb/paycheck.JPG'
    when 'pokesteak'
      m.reply 'http://chewbotcca.co/memedb/pokesteak.JPG'
    when 'losthope'
      m.reply 'http://chewbotcca.co/memedb/losthope.png'
    when 'timetostop'
      m.reply 'http://chewbotcca.co/memedb/timetostop.gif'
    when 'trap'
      m.reply 'http://chewbotcca.co/memedb/trap.jpeg'
    when 'triggered'
      m.reply 'https://chewbotcca.co/memedb/triggered.gif'
    when 'noot'
      m.reply 'https://chewbotcca.co/memedb/noot.gif'
    when 'iplayedmyself'
      m.reply 'https://chewbotcca.co/memedb/iplayedmyself.png'
    when 'submit'
      m.reply 'You can submit a meme here: http://goo.gl/forms/BRMomYVizsY7SqOg2'
    else
      m.reply "This meme doesn't exist! Make sure you spell the meme name right. Here is a list of the current memes: `rickroll, vegans, spotad, petpet, nicememe, paycheck, pokesteak, losthope, timetostop, trap, triggered, noot, iplayedmyself`"
    end
  end
end
