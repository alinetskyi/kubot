require 'http'
require 'json'

module Kubot
  class MyServer < SlackRubyBot::Server
    on 'message' do |client, data|
      if data.team != SLACK_SUPPORT_TEAM
=begin
        HTTP.post('https://slack.com/api/chat.postMessage', params: {
          text: "#{$channels}",
          channel: 'CCQN7JBHU',
          token: $db.get_team_bot_token('TCQG7CCMC')
        })
=end
        if $db.select_support_channel(data.channel) != nil 
          HTTP.post('https://slack.com/api/chat.postMessage', params: { 
            text: "#{$db.get_team_name(data.team)}: #{data.text}", 
            channel: $db.select_support_channel(data.channel),
            token: $db.get_team_bot_token(SLACK_SUPPORT_TEAM)})
        else 
          JSON.parse(HTTP.post('https://slack.com/api/conversations.create', params: {
            name: $db.get_team_name(data.team).to_s.downcase.delete(' ')+'_support'+Random.rand(100).to_s , 
            token: $db.get_team_token(SLACK_SUPPORT_TEAM)}))
          HTTP.post('https://slack.com/api/chat.postMessage', params: {
            text: "#{$db.get_team_name(data.team)}: #{data.text}",
            channel: $db.select_support_channel(data.channel),
            token: $db.get_team_bot_token(SLACK_SUPPORT_TEAM)})
          #self.set_support_channel(rc, data)
        end
=begin
        HTTP.post('https://slack.com/api/chat.postMessage', params: {
        text: "#{rc}",
        channel: 'CCQN7JBHU',
        token: $teams['TCQG7CCMC'][2]
        })
=end
      else
        if $db.select_ask_channel(data.channel) != nil
          HTTP.post('https://slack.com/api/chat.postMessage', params: {
            text: "#{data.text}",
            channel: $db.select_ask_channel(data.channel),
            token: $db.get_team_bot_token(data.team)
          })
=begin
          HTTP.post('https://slack.com/api/chat.postMessage', params: { 
            text: "#{rc}",                                 
            channel: $channels.key(data.channel),
            token: $teams['TCQG7CCMC'][2]})
=end
        end
      end
    end
=begin
    #Gets teams name 
    def self.get_team_name(token)
      rc = JSON.parse(HTTP.get('https://slack.com/api/team.info', params: {token: token}))
      return rc['team']['name']
    end
    #Sets support channel id
    def self.set_support_channel(rc, data)
      if rc['ok']
        $channels[data.channel] = rc['channel']['id']
      end 
    end
=end
  end
end
