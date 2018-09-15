require 'http'
require 'json'

module Kubot
  class MyServer < SlackRubyBot::Server

    on :channel_joined do |client, data|
      puts "client:",client, "data:", data
      client.say(text: "Hello, I'm kubot I can help you with any issue.\nJust DM me or add me to the channel and tag me when you want some support!", channel: data.channel.id)
      #explain how to communicate with Kubot
    end 

    on :message do |client, data|
      if data.team == SLACK_SUPPORT_TEAM && data.bot_id.nil? 
        answer_question(data)
      end
    end

    def self.answer_question(data)
      channel = format_query(Setup.db.select_ask_channel(data.channel))
      token = format_query(Setup.db.get_ask_bot_token(channel))
      text = data.text.split("> ").last
        if !data.files.nil?
          send_message(text +"\n_Kubot is sharing a file with you:_" + "\n#{data.files[0]['permalink_public']}",channel,token) 
          share_file_publically(data)
        else
          send_message(text, channel,token)
        end
    end

    def self.send_message(text, channel,token)
      rc = JSON.parse(HTTP.post('https://slack.com/api/chat.postMessage', params: {
            text: text,
            channel: channel,
            token:  token,
            as_user: true,
            mrkdwn: true,
            unfurl_links: true,
            unfurl_media: true
      }))
      puts "<<<<<<Sending.say>>>>>>", rc
    end

    def self.ask_question(data)
      text = "#{format_query(Setup.db.get_team_name(data.team))}"+"@#{get_user_info(data)['user']['real_name']}: #{data.text.split(">").last}" 
      token = format_query(Setup.db.get_team_bot_token(SLACK_SUPPORT_TEAM))

      begin
      channel = format_query(Setup.db.select_support_channel(data.channel))
        if !data.files.nil?
            send_message(text+"\n#{data.files[0]['permalink_public']}",channel,token)
            share_file_publically(data)
        else
            send_message(text,channel,token)
        end
      rescue
        chan_name = format_query(Setup.db.get_team_name(data.team)).downcase.delete(' ')+'_'+get_channel_info(data)
          rc = JSON.parse(HTTP.post('https://slack.com/api/conversations.create', params: {
            name: chan_name.to_s[0,20],
            token: format_query(Setup.db.get_team_token(SLACK_SUPPORT_TEAM))}))
          puts rc
          JSON.parse(HTTP.post('https://slack.com/api/conversations.invite', params: {
            channel: rc['channel']['id'],
            token: format_query(Setup.db.get_team_token(SLACK_SUPPORT_TEAM)),
            users: format_query(Setup.db.get_bot_id(SLACK_SUPPORT_TEAM))
          }))

          set_support_channel(rc, data)
          send_message(text,rc['channel']['id'],token)
      end
    end

    def self.share_file_publically(data)
      rc = JSON.parse(HTTP.post('https://slack.com/api/files.sharedPublicURL', params: {
        token: format_query(Setup.db.get_team_token(data.team)),
        file: data.files[0]['id']
      }))
      puts "<<<<<<<<<<<Sharing file>>>>>>>>>", rc
    end

    def self.get_user_info(data)
      rc = JSON.parse(HTTP.get('https://slack.com/api/users.info', params: {
        token: format_query(Setup.db.get_team_bot_token(data.team)),
        user: data.user
      }))
      puts "<<<<<<<<<<<Getting user info >>>>>>>>>>>", rc
      return rc
    end

    def self.get_channel_info(data)
      rc = JSON.parse(HTTP.get('https://slack.com/api/channels.info', params: {
        token: Setup.db.get_team_bot_token(data.team),
        channel: data.channel}))
      puts "<<<<<<<<<<<Getting channel info >>>>>>>>>", rc
      if rc['ok'] == true
        return rc['channel']['name']
      else
        return get_user_info(data)['user']['name']
      end
    end

    def self.format_query(query)
      return query[0].to_s
    end

    def self.set_support_channel(rc, data)
      if rc['ok']
        Setup.db.add_channels(rc['channel']['id'], data.channel,Setup.db.get_team_bot_token(SLACK_SUPPORT_TEAM),Setup.db.get_team_bot_token(data.team))
      end
    end
  end
end
