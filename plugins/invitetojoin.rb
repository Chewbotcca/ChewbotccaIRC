class InviteToJoin
  include Cinch::Plugin

  listen_to :invite, method: :invite
  match /leave/, method: :leave

  def invite(m)
    channels = CONFIG['channels'].split(',')
    channels += [m.channel]
    CONFIG['channels'] = channels.join(',')
    File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
    Channel(m.channel.to_s).join
  end

  def leave(m)
    if m.channel.half_ops.join(' ').split(' ').include?(m.user.nick) || m.channel.ops.join(' ').split(' ').include?(m.user.nick) || m.channel.admins.join(' ').split(' ').include?(m.user.nick) || m.channel.owners.join(' ').split(' ').include?(m.user.nick)
      channels = CONFIG['channels'].split(',')
      channels -= [part]
      CONFIG['channels'] = channels.join(',')
      File.open('config.yaml', 'w') { |f| f.write CONFIG.to_yaml }
      m.reply 'Bye!'
      Channel(m.channel).part
    else
      m.reply 'Only half-ops and above may force me to leave!'
    end
  end
end
