require 'http'
require 'json'

module Kubot
  class MyServer < SlackRubyBot::Server
=begin
    on 'message' do |client, data|
      if data.team != SLACK_SUPPORT_TEAM && data.username = "Kubot"
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
      else
      if data.subtype != 'bot_message' 
          JSON.parse(HTTP.post('https://slack.com/api/chat.postMessage', params: {
            text: "#{data.text}",
            channel: format_query($db.select_ask_channel(data.channel)),
            token: format_query($db.get_ask_bot_token(format_query($db.select_ask_channel(data.channel)))),
            as_user: 'true'
          }))
      end
      end
    end
=end

    def self.answer_question(data)
      JSON.parse(HTTP.post('https://slack.com/api/chat.postMessage', params: {
            text: "#{data.text.split("ans ").last}",
            channel: format_query($db.select_ask_channel(data.channel)),
            token: format_query($db.get_ask_bot_token(format_query($db.select_ask_channel(data.channel)))),
            as_user: 'true'
          }))
    end

    def self.ask_question(data)
      begin
          rc = HTTP.post('https://slack.com/api/chat.postMessage', params: { 
            text: "#{format_query($db.get_team_name(data.team))}@#{get_user_info(data)[0]}: #{data.text.split('ask ').last}", 
            channel: format_query($db.select_support_channel(data.channel)),
            token: format_query($db.get_team_bot_token(SLACK_SUPPORT_TEAM))})
=begin
          HTTP.post('https://slack.com/api/chat.postMessage', params: { 
            text: rc,  
            channel: 'CCQN7JBHU', 
            token: $db.get_team_bot_token(SLACK_SUPPORT_TEAM)[0].to_s})
=end
      rescue
          chan_name = format_query($db.get_team_name(data.team)).downcase.delete(' ')+'_'+get_channel_info(data)
          rc = JSON.parse(HTTP.post('https://slack.com/api/conversations.create', params: {
            name: chan_name[0,20], 
            token: format_query($db.get_team_token(SLACK_SUPPORT_TEAM))}))
          JSON.parse(HTTP.post('https://slack.com/api/conversations.invite', params: {
            channel: rc['channel']['id'],
            token: format_query($db.get_team_token(SLACK_SUPPORT_TEAM)),
            users: format_query($db.get_bot_id(SLACK_SUPPORT_TEAM))
          }))
          set_support_channel(rc, data)
          puts "================================================================", rc, chan_name
          HTTP.post('https://slack.com/api/chat.postMessage', params: {
            text: "#{format_query($db.get_team_name(data.team))}@#{get_user_info(data)[0]}: #{data.text.split('ask ').last}",
            channel:  format_query($db.select_support_channel(data.channel)),
            token: format_query($db.get_team_bot_token(SLACK_SUPPORT_TEAM))})
      end
    end

    def self.get_user_info(data)
      rc = JSON.parse(HTTP.get('https://slack.com/api/users.info', params: {
        token: format_query($db.get_team_bot_token(data.team)),
        user: data.user
      }))
      if rc["ok"] == true
        return rc['user']['real_name'].to_s, rc['user']['name'].to_s
      else
        puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++",rc
      end
    end

    def self.get_channel_info(data)
      rc = JSON.parse(HTTP.get('https://slack.com/api/channels.info', params: {
        token: $db.get_team_bot_token(data.team),
        channel: data.channel}))
      puts rc
      if rc['ok'] == true 
          return rc['channel']['name']
        else
          return get_user_info(data)[1]
      end
    end


    def self.format_query(query)
      return query[0].to_s
    end

    def self.set_support_channel(rc, data)
      if rc['ok']
        $db.add_channels(rc['channel']['id'], data.channel,$db.get_team_bot_token(SLACK_SUPPORT_TEAM),$db.get_team_bot_token(data.team))
      end
    end

  end
end
