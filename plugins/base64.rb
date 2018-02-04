class BaseS4
  include Cinch::Plugin

  match /base64 (.+)/, method: :base64
  match /debase64 (.+)/, method: :debase
  match /isbase64 (.+)/, method: :isbase

  def isbase(m, args)
    decoded = Base64.decode64(args)
    if decoded == ''
      m.reply "String \"#{args}\" is not base64!"
    else
      m.reply "String \"#{args}\" is base64!"
    end
  end

  def base64(m, args)
    m.reply Base64.encode64(args)
  end

  def debase(m, args)
    decoded = Base64.decode64(args)
    if decoded == ''
      m.reply 'Boi whatchu doin? that aint base64! get outta here wit yo basealphabet nonsense.'
    else
      m.reply decoded
    end
  end
end
