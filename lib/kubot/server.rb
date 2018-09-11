require 'http'
require 'json'

module Kubot
  class MyServer < SlackRubyBot::Server
    on 'message' do |client, data|
      if data.team != 'TCQG7CCMC'
        HTTP.post('https://slack.com/api/chat.postMessage', params: {
          text: "#{$channels}",
          channel: 'CCQN7JBHU',
          token: $teams['TCQG7CCMC'][2]
        })
        if $channels.key?(data.channel)
          HTTP.post('https://slack.com/api/chat.postMessage', params: { 
            text: "#{data.channel}:#{data.text}", 
            channel: $channels[data.channel],
            token: $teams['TCQG7CCMC'][2]})
        else 
          rc = JSON.parse(HTTP.post('https://slack.com/api/conversations.create', params: {
            name: self.get_team_name($teams[data.team][2]).to_s.downcase.delete(' ')+'_support'+Random.rand(100).to_s , 
            token: $teams['TCQG7CCMC'][1]}))
          self.set_support_channel(rc, data)
        end
        HTTP.post('https://slack.com/api/chat.postMessage', params: {
        text: "#{rc}",
        channel: 'CCQN7JBHU',
        token: $teams['TCQG7CCMC'][2]
        })
      else
        if $channels.has_value?(data.channel) 
          rc = HTTP.post('https://slack.com/api/chat.postMessage', params: {
            text: "#{data.text}",
            channel: $channels.key(data.channel),
            token: $teams[$team_channel[$channels.key(data.channel)]][2]
          })
          HTTP.post('https://slack.com/api/chat.postMessage', params: { 
            text: "#{rc}",                                 
            channel: $channels.key(data.channel),     
            token: $teams['TCQG7CCMC'][2]})  
        end
      end
    end
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
  end
end
