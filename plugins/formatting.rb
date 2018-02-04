class Formatting
  include Cinch::Plugin

  match /rainbow (.+)/, method: :rainbow
  match /wrainbow (.+)/, method: :rainbow
  match /colorbarf (.+)/, method: :colorbarf
  match /multicolor (.+)/, method: :colorbarf
  match /usa (.+)/, method: :usa

  def colorbarf(m, args)
    args = args.split('')
    amount = args.length
    current = 0
    message = Array.new(amount, '')
    while current < amount
      begin
        message[current] = "#{rand(1..99)}#{args[current]}"
        current -= 1
      rescue
        current = amount
      end
    end
    m.reply message.join('')
  end

  def rainbow(m, args)
    rainbow = "#{CONFIG['prefix']}rainbow"
    wrainbow = "#{CONFIG['prefix']}wrainbow"
    case m.params[1].split(' ')[0]
    when rainbow
      args = args.split('')
    when wrainbow
      args = args.split(' ')
    else
      return
    end
    amount = args.length
    current = 0
    message = Array.new(amount, '')
    while current < amount
      begin
        message[current] = Format(:red, args[current])
        current += 1
        message[current] = Format(:orange, args[current])
        current += 1
        message[current] = Format(:yellow, args[current])
        current += 1
        message[current] = Format(:lime, args[current])
        current += 1
        message[current] = Format(:green, args[current])
        current += 1
        message[current] = Format(:teal, args[current])
        current += 1
        message[current] = Format(:aqua, args[current])
        current += 1
        message[current] = Format(:blue, args[current])
        current += 1
        message[current] = Format(:purple, args[current])
        current += 1
        message[current] = Format(:pink, args[current])
        current += 1
      rescue
        current = amount
      end
    end
    case m.params[1].split(' ')[0]
    when rainbow
      m.reply message.join('')
    when wrainbow
      m.reply message.join(' ')
    end
  end

  def usa(m, args)
    # ITS TIME TO USA IT UP
    # U S A
    args = args.split('')
    amount = args.length
    current = 0
    message = Array.new(amount, '')
    while current < amount
      begin
        message[current] = Format(:red, args[current])
        current += 1
        message[current] = Format(:white, args[current])
        current += 1
        message[current] = Format(:blue, args[current])
        current += 1
      rescue
        current = amount
      end
    end
    m.reply message.join('')
  end
end
