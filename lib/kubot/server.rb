require "http"
require "json"

module Kubot
  class MyServer < SlackRubyBot::Server
    on :channel_joined do |client, data|
      puts "client:", client, "data:", data
      client.say(text: "Hello, I'm kubot I can help you with any issue.\nJust DM me or add me to the channel and tag me when you want some support!",
                 channel: data.channel.id)
      #explain how to communicate with Kubot
    end

    on :message do |client, data|
      if data.team == SLACK_SUPPORT_TEAM && data.bot_id.nil?
        answer_question(data)
      end
    end

    def self.answer_question(data)
      channel = format_query(Main.db.select_ask_channel(data.channel))
      token = format_query(Main.db.get_ask_bot_token(channel))
      text = data.text.split("> ").last || "I've found an answer for you"
      if !data.files.nil?
        send_message(text + "\n_Kubot is sharing a file with you:_" + "\n#{data.files[0]["permalink_public"]}", channel, token)
        share_file_publically(data)
      else
        send_message(text, channel, token)
      end
    end

    def self.send_message(text, channel, token)
      rc = JSON.parse(HTTP.post("https://slack.com/api/chat.postMessage", params: {
                                                                            text: text,
                                                                            channel: channel,
                                                                            token: token,
                                                                            as_user: true,
                                                                            mrkdwn: true,
                                                                            unfurl_links: true,
                                                                            unfurl_media: true,
                                                                          }))
      puts "<<<<<<Sending.say>>>>>>", rc
    end

    def self.ask_question(data)
      text = "#{format_query(Main.db.get_team_name(data.team))}" + "@#{get_user_info(data)["user"]["real_name"]}: #{data.text.split(">").last}"
      token = format_query(Main.db.get_team_bot_token(SLACK_SUPPORT_TEAM))

      begin
        channel = format_query(Main.db.select_support_channel(data.channel))
        if !data.files.nil?
          send_message(text + "\n#{data.files[0]["permalink_public"]}", channel, token)
          share_file_publically(data)
        else
          send_message(text, channel, token)
        end
      rescue
        chan_name = format_query(Main.db.get_team_name(data.team)).downcase.delete(" ") + "_" + get_channel_info(data)
        if data.team != SLACK_SUPPORT_TEAM
          new_convers_resp = JSON.parse(HTTP.post("https://slack.com/api/conversations.create", params: {
                                                                                    name: chan_name.to_s[0, 20],
                                                                                    token: format_query(Main.db.get_team_token(SLACK_SUPPORT_TEAM)),
                                                                                  }))
          puts new_convers_resp 

          invite_to_convers(new_convers_resp['channel']['id'],format_query(Main.db.get_bot_id(SLACK_SUPPORT_TEAM)))
          if !ENV['SLACK_SUPPORT_USERS'].nil? 
            ENV['SLACK_SUPPORT_USERS'].split.each do |user|
              invite_to_convers(new_convers_resp['channel']['id'],user)
            end
          end
          set_support_channel(new_convers_resp, data)
          send_message(text, new_convers_resp["channel"]["id"], token)
        end
      end
    end


    def self.invite_to_convers(convers_id, users_id)
      invite_user_resp = JSON.parse(HTTP.post("https://slack.com/api/conversations.invite", params: {
        channel: convers_id,
        token: format_query(Main.db.get_team_token(SLACK_SUPPORT_TEAM)),
        users: users_id,
      }))
      puts "<<<<<<<<<<<<<<<<<<<<<<< Invite bot to new conversation >>>>>>>>>>>>>>>>>>>>>>>>>>", invite_user_resp
      return invite_user_resp
    end

    def self.share_file_publically(data)
      share_file_resp = JSON.parse(HTTP.post("https://slack.com/api/files.sharedPublicURL", params: {
                                                                                 token: format_query(Main.db.get_team_token(data.team)),
                                                                                 file: data.files[0]["id"],
                                                                               }))
      puts "<<<<<<<<<<<Sharing file>>>>>>>>>", share_file_resp
      return share_file_resp
    end

    def self.get_user_info(data)
      user_info_resp = JSON.parse(HTTP.get("https://slack.com/api/users.info", params: {
                                                                     token: format_query(Main.db.get_team_bot_token(data.team)),
                                                                     user: data.user,
                                                                   }))
      puts "<<<<<<<<<<<Getting user info >>>>>>>>>>>", user_info_resp
      return user_info_resp
    end

    def self.get_channel_info(data)
      chann_info_resp = JSON.parse(HTTP.get("https://slack.com/api/channels.info", params: {
                                                                        token: Main.db.get_team_bot_token(data.team),
                                                                        channel: data.channel,
                                                                      }))
      puts "<<<<<<<<<<<Getting channel info >>>>>>>>>", chann_info_resp
      if chann_info_resp["ok"] == true
        return chann_info_resp["channel"]["name"]
      else
        return get_user_info(data)["user"]["name"]
      end
    end

    def self.format_query(query)
      return query[0].to_s
    end

    def self.set_support_channel(response, data)
      if response["ok"]
        Main.db.add_channels(response["channel"]["id"], data.channel, Main.db.get_team_bot_token(SLACK_SUPPORT_TEAM), Main.db.get_team_bot_token(data.team))
      end
    end
  end
end
