class Grammar
  include Cinch::Plugin

  match /reverse (.+)/, method: :reverse
  match /length (.+)/, method: :length
  match /capitalize (.+)/, method: :cap
  match /cap (.+)/, method: :cap
  match /upper (.+)/, method: :up
  match /upcase (.+)/, method: :up
  match /up (.+)/, method: :up
  match /uppercase (.+)/, method: :up
  match /downcase (.+)/, method: :down
  match /down (.+)/, method: :down
  match /derpify (.+)/, method: :derp
  match /titlecase (.+)/, method: :titlecase
  match /title (.+)/, method: :titlecase

  def derp(m, args)
    args.upcase!
    args = args.gsub('BECAUSE', %w[BECUZ BECAS CUZ BECZ].sample.to_s)
    args = args.gsub('THAT', %w[DAT TAT DHAT DATA THAT].sample.to_s)
    args = args.gsub('SCHOOL', %w[SKEWL SCHEWL SCOOL SKMOOP SKOWL].sample.to_s)
    args = args.gsub('LIKE', %w[LIAK LIEK LOKE LICK LIKE].sample.to_s)
    args = args.gsub('HELP', %w[HALP HEEPL HAAPLE HELP].sample.to_s)
    args = args.gsub('THE', %w[TEH DA DAH THE].sample.to_s)
    args = args.gsub('?', ['??!!!', '!?!?!?!?!', '??!???!', '??????'].sample.to_s)
    args = args.gsub('!', ['!!!!1111!11', '!!!11!!11!1', '!!111!1'].sample.to_s)
    args = args.gsub('YOU\'RE', %w[UR YOUR YORE].sample.to_s)
    args = args.gsub('YOUR', ['UR', 'YOUR', 'YOU\'RE', 'YORE'].sample.to_s)
    args = args.gsub('PLEASE', %w[PLSSSS PLZ PLEEE].sample.to_s)
    args = args.gsub('E', %w[E 3].sample.to_s)
    args = "#{args} #{['WTF', 'WTF LOL', 'LOL', 'OMG', '', 'OMG LOL'].sample}"
    m.reply args
  end

  def up(m, message)
    m.reply message.upcase
  end

  def down(m, message)
    m.reply message.downcase
  end

  def cap(m, message)
    m.reply message.capitalize
  end

  def length(m, string)
    m.reply "That string has #{string.length} characters."
  end

  def reverse(m, string)
    m.reply string.reverse
  end

  def titlecase(m, string)
    m.reply string.gsub(/\w+/, &:capitalize)
  end
end
