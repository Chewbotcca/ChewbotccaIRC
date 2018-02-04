class Emoji
  include Cinch::Plugin

  match /b (.+)/, method: :b
  match /:b: (.+)/, method: :b
  match /🅱️ (.+)/, method: :b
  match /clap (.+)/, method: :clap
  match /:clap: (.+)/, method: :clap
  match /👏 (.+)/, method: :clap
  match /spread (.+)/, method: :spread
  match /br (.+)/, method: :breplace
  match /breplace (.+)/, method: :breplace
  match /:b:replace (.+)/, method: :breplace
  match /🅱️replace (.+)/, method: :breplace
  match /tm (.+)/, method: :tm
  match /™ (.+)/, method: :tm

  def spread(m, args)
    m.reply args.split('').join(' ')
  end

  def b(m, args)
    m.reply args.gsub('b', '🅱️').gsub('B', '🅱️')
  end

  def clap(m, args)
    m.reply args.gsub(' ', ' 👏 ')
  end

  def breplace(m, args)
    args = args.split(' ')
    amount = args.length
    current = 0
    while current < amount
      getsplit = args[current].split('')
      getsplit[0] = '🅱️'
      args[current] = getsplit.join('')
      current += 1
    end
    m.reply args.join(' ')
  end

  def tm(m, args)
    args = args.split(' ')
    amount = args.length
    current = 0
    while current < amount
      args[current] = "#{args[current]}™"
      current += 1
    end
    m.reply args.join(' ')
  end
end
