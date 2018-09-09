module Kubot
  class Bot < SlackRubyBot::Bot
  @support_channel = ENV['SLACK_SUPPORT_CHANNEL']
  command 'hi' do |client,data,match|
    if data.team != 'T8XPR1RA7'
   HTTP.post('https://slack.com/api/chat.postMessage', params: {
    text: "#{$teams}",
     #"*#{$team_names[data.team]}*//_#{data.channel}_: #{data.text}",
     channel: 'CCKSU9WQ4',
     token: $teams['T8XPR1RA7']
        })
    rc = JSON.parse(HTTP.post('https://slack.com/api/conversations.create', params: {
     name: "new_conversation",
   token: $team_names['T8XPR1RA7']
    }))
  HTTP.post('https://slack.com/api/chat.postMessage', params: {
     text: "#{rc}",
    #"*#{$team_names[data.team]}*//_#{data.channel}_: #{data.text}",
     channel: 'CCKSU9WQ4',
     token: $teams['T8XPR1RA7']
    })
    #client.message text: "hi <@#{data.user}>", channel: 'CCKSU9WQ4', token: $teams['T8XPR1RA7']
   else
    client.message text: "*#{$team_names[data.team]}*//_#{data.channel}_: #{data.text}", channel: 'CCKSU9WQ4'
   end
  end

  command 'help' do |client,data,match|
    client.say(
      channel: data.channel,
      text: ":spock-hand:\n *I'm a support Kubot*\n_You can either DM me or use any of these commands:_\n•hi\n•help\n•about",
      mrkdwn: true)
  end

  command 'about' do |client,data,match|
    client.say(
      channel: data.channel,
      text: "I'm here to provide you help with any question you have about Peatio or Rubykube stack\nIf you want to get a valuable answer you need to provide a clear and easy to understand question\notherwise I might struggle to undestand you.\nIf you want to know what I can do just type in `help`\nI'm proficient in this list of topics:\n•Peatio\n•Barong\n•Deployment\n•Applogic\n•Trading-UI",
      mrkdwn: true)
  end

  command 'ask' do |client,data,match|
    client.say(
      channel: @support_channel,
      text: "#{data.channel}| <@#{data.user}> : #{data.text.delete!('ask')}"
    )
  end

    match(/^(?<bot>\S*)[\s]*(?<expression>.*)$/)
      def self.call(client, data, _match)
        @keywords = ["peatio","barong","workbench","applogic","trading-ui","docker","currency","cold wallet","hot wallet","authorization","2FA","2fa","cluster","totp"]
          @keywords.each do |keyword|
            if data.text.include? keyword
              client.say(channel: data.channel, text: "Hold on <@#{data.user}> I need to ask one of the specialists! ")
              client.say(channel: ENV['SLACK_SUPPORT_CHANNEL'], text: "#{data.channel}| <@#{data.user}> : #{data.text}")
              return
            end 
          end
            client.say(channel: data.channel, text: "Sorry, I'm not sure I have answer to that question, Could you try to say it differently?")
      end
  end
end
