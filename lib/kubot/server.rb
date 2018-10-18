require "http"
require "json"
require "logger"

module Kubot
  class KubotServer < SlackRubyBot::Server
    @logger = Logger.new(STDOUT)
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

    # Redirects message from support team workspace to workspace where question was asked 
    def self.answer_question(data)
      channel = format_query(Main.db.select_ask_channel(data.channel))
      token = format_query(Main.db.get_ask_bot_token(channel))
      text = data.text.split("> ").last || "I've found an answer for you"
      if !data.files.nil?
        send_message(text + "\n_Kubot is sharing a file with you:_" + "\n#{data.files[0]["permalink_public"]}", channel, token)
        share_file_pub(data)
      else
        send_message(text, channel, token)
      end
    end

    # Makes api call chat.postMessage
    def self.send_message(text, channel, token)
      post_msg_resp = JSON.parse(HTTP.post("https://slack.com/api/chat.postMessage", params: {
                                                                            text: text,
                                                                            channel: channel,
                                                                            token: token,
                                                                            as_user: true,
                                                                            mrkdwn: true,
                                                                            unfurl_links: true,
                                                                            unfurl_media: true,
                                                                          }))
      @logger.debug("KubotServer#send_message: "+ post_msg_resp.to_s)
      return post_msg_resp
    end

    # Redirects message to support team workspace including links for attachments 
    def self.ask_question(data)
      text = "_#{format_query(Main.db.get_team_name(data.team))}" + "@#{get_user_info(data)["user"]["real_name"]}_: #{data.text.split(">").last}"
      token = format_query(Main.db.get_team_bot_token(SLACK_SUPPORT_TEAM))
      begin
        channel = format_query(Main.db.select_support_channel(data.channel))
        if !data.files.nil?
          send_message(text + "\n#{data.files[0]["permalink_public"]}", channel, token)
          share_file_pub(data)
        else
          send_message(text, channel, token)
        end
      rescue
        chan_name = format_query(Main.db.get_team_name(data.team)).downcase.delete(" ") + "_" + get_channel_info(data)
        if data.team != SLACK_SUPPORT_TEAM
          new_convers_resp = create_convers(chan_name.to_s[0,20],format_query(Main.db.get_team_token(SLACK_SUPPORT_TEAM)))
          if !new_convers_resp['ok']
            new_convers_resp = join_convers(chan_name.to_s[0,20],format_query(Main.db.get_team_token(SLACK_SUPPORT_TEAM)))
          else
            invite_to_convers(new_convers_resp['channel']['id'],format_query(Main.db.get_team_token(SLACK_SUPPORT_TEAM)),format_query(Main.db.get_bot_id(SLACK_SUPPORT_TEAM)))
          end
          set_support_channel(new_convers_resp, data)
          send_message(text, new_convers_resp["channel"]["id"], token)
        end
      end
    end

    def self.invite_support_users(new_convers_resp)
      begin
        ENV['SLACK_SUPPORT_USERS'].split.each do |user|
            invite_to_convers(new_convers_resp['channel']['id'],format_query(Main.db.get_team_token(SLACK_SUPPORT_TEAM)),user)
        end
      rescue
        @logger.error("SLACK_SUPPORT_USERS are set incorrectly")
      end
    end

    def self.create_convers(name, token) 
      new_convers_resp = JSON.parse(HTTP.post("https://slack.com/api/conversations.create", params: {
        name: name,
        token: token,
        }))
      @logger.debug("KubotServer#create_convers: " + new_convers_resp.to_s)
      return new_convers_resp
    end

    def self.join_convers(name,token)
      join_existing_convers = JSON.parse(HTTP.post("https://slack.com/api/channels.join",params: {
      name: name,
      token: token,
}))
      @logger.debug("KubotServer#join_convers: "+join_existing_convers.to_s)
      return join_existing_convers
    end

    # Invites users to channels making api call conversations.invite
    def self.invite_to_convers(convers_id, token, users_id)
      invite_user_resp = JSON.parse(HTTP.post("https://slack.com/api/conversations.invite", params: {
        channel: convers_id,
        token: token, 
        users: users_id,
      }))
      @logger.debug("KubotServer#invite_to_convers: " + invite_user_resp.to_s)
      return invite_user_resp
    end

    # Makes attachment publically accessible to be able to share it with support
    def self.share_file_pub(data)
      share_file_resp = JSON.parse(HTTP.post("https://slack.com/api/files.sharedPublicURL", params: {
                                                                                 token: format_query(Main.db.get_team_token(data.team)),
                                                                                 file: data.files[0]["id"],
                                                                               }))
      @logger.debug("KubotServer#share_file_pub: " + share_file_resp.to_s)
      return share_file_resp
    end

    # Returns user information by making api call to users.info
    def self.get_user_info(data)
      user_info_resp = JSON.parse(HTTP.get("https://slack.com/api/users.info", params: {
                                                                     token: format_query(Main.db.get_team_bot_token(data.team)),
                                                                     user: data.user,
                                                                   }))
      @logger.debug("KubotServer#get_user_info: " + user_info_resp.to_s)
      return user_info_resp
    end

    # Returns channel information by making api call to channels.info
    def self.get_channel_info(data)
      chann_info_resp = JSON.parse(HTTP.get("https://slack.com/api/channels.info", params: {
                                                                        token: Main.db.get_team_bot_token(data.team),
                                                                        channel: data.channel,
                                                                      }))
      @logger.debug("KubotServer#get_channel_info: "+ chann_info_resp.to_s)
      if chann_info_resp["ok"] == true
        return chann_info_resp["channel"]["name"]
      else
        return get_user_info(data)["user"]["name"]
      end
    end

    # Formats query result from database
    def self.format_query(query)
      return query[0].to_s
    end

    # Writes support and corresponding ask channel id's to database, including bot token and team token 
    def self.set_support_channel(response, data)
      if response["ok"]
        Main.db.add_channels(response["channel"]["id"], data.channel, Main.db.get_team_bot_token(SLACK_SUPPORT_TEAM), Main.db.get_team_bot_token(data.team))
      end
    end
  end
end
