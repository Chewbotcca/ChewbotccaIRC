class GitHub
  include Cinch::Plugin

  match /ghissue (.+) (.+)/, method: :ghissue
  match /ghpull (.+) (.+)/, method: :ghissue
  match %r{(https?://.*?)(?:\s|$|,|\.\s|\.$)}, use_prefix: false, method: :grabinfo

  def grabinfo(m, url)
    url = url.split('/')
    if url[2] == 'github.com'
      if url[5] == 'issue' || url[5] == 'pull'
        repo = "#{url[3]}/#{url[4]}"
        issuenum = url[6]
        ghissue(m, repo, issuenum, false)
      end
    end
  end

  def ghissue(m, repo, issuenum, showurl = true)
    issuenum = JSON.parse(RestClient.get("https://api.github.com/repos/#{repo}/issues"))[0]['number'].to_i if issuenum == 'latest'
    issueurl = "https://api.github.com/repos/#{repo}/issues/#{issuenum}"
    begin
      parsed = JSON.parse(RestClient.get(issueurl))
    rescue
      m.reply 'Invalid Repo or Issue number!'
      return
    end
    issueorpull = parsed['html_url'].split('/')[5]
    issueorpull = 'Issue' if issueorpull == 'issues'
    issueorpull = 'Pull' if issueorpull == 'pull'
    status = parsed['state']
    if status == 'closed'
      statusformatted = Format(:bold, Format(:red, 'Closed'))
      statusformatted += " by #{parsed['closed_by']['login']}"
    end
    statusformatted = Format(:bold, Format(:green, 'Open')) if status == 'open'
    if showurl == true
      m.reply "GitHub #{issueorpull} ##{issuenum} (#{statusformatted}): #{parsed['html_url']} | #{parsed['title']}"
    else
      m.reply "GitHub #{issueorpull} ##{issuenum} (#{statusformatted}): #{parsed['title']}"
    end
  end
end
