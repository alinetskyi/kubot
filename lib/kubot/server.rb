require 'http'
require 'json'

module Kubot
  class MyServer < SlackRubyBot::Server
    on 'message' do |client, data|
      if data.team != SLACK_SUPPORT_TEAM && data.username = "Kubot"
=begin
        begin
          HTTP.post('https://slack.com/api/chat.postMessage', params: { 
            text: "#{$db.get_team_name(data.team).to_s}: #{data.text}", 
            channel: $db.select_support_channel(data.channel)[0].to_s,
            token: $db.get_team_bot_token(SLACK_SUPPORT_TEAM)[0].to_s})
        rescue
          rc = JSON.parse(HTTP.post('https://slack.com/api/conversations.create', params: {
            name: $db.get_team_name(data.team)[0].to_s.downcase.delete(' ')+'_support'+Random.rand(100).to_s , 
            token: $db.get_team_token(SLACK_SUPPORT_TEAM)[0].to_s}))
          set_support_channel(rc, data)
          HTTP.post('https://slack.com/api/chat.postMessage', params: {
            text: "#{$db.get_team_name(data.team).to_s}: #{data.text} #{$db.select_ask_channel($db.select_support_channel(data.channel)[0].to_s)[0].to_s}",
            channel:  $db.select_support_channel(data.channel)[0].to_s, 
            token: $db.get_team_bot_token(SLACK_SUPPORT_TEAM)[0].to_s})
        end
=end
      else
      if data.subtype != 'bot_message' 
          rc = JSON.parse(HTTP.post('https://slack.com/api/chat.postMessage', params: {
            text: "#{data.text}",
            channel: $db.select_ask_channel(data.channel)[0].to_s,
            token: $db.get_ask_bot_token($db.select_ask_channel(data.channel)[0].to_s)[0].to_s,
            as_user: 'true'
          }))
      end
      end
    end

    def self.set_support_channel(rc, data)
      if rc['ok']
        $db.add_channels(rc['channel']['id'], data.channel,$db.get_team_bot_token(SLACK_SUPPORT_TEAM),$db.get_team_bot_token(data.team))
      end 
    end
    
    def self.ask_question(data)
       begin
          HTTP.post('https://slack.com/api/chat.postMessage', params: { 
            text: "#{$db.get_team_name(data.team).to_s}: #{data.text}", 
            channel: $db.select_support_channel(data.channel)[0].to_s,
            token: $db.get_team_bot_token(SLACK_SUPPORT_TEAM)[0].to_s})
        rescue
          rc = JSON.parse(HTTP.post('https://slack.com/api/conversations.create', params: {
            name: $db.get_team_name(data.team)[0].to_s.downcase.delete(' ')+'_support'+Random.rand(100).to_s , 
            token: $db.get_team_token(SLACK_SUPPORT_TEAM)[0].to_s}))
          set_support_channel(rc, data)
          HTTP.post('https://slack.com/api/chat.postMessage', params: {
            text: "#{$db.get_team_name(data.team).to_s}: #{data.text} #{$db.select_ask_channel($db.select_support_channel(data.channel)[0].to_s)[0].to_s}",
            channel:  $db.select_support_channel(data.channel)[0].to_s, 
            token: $db.get_team_bot_token(SLACK_SUPPORT_TEAM)[0].to_s})
        end
    end
  end
end
