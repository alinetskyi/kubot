require 'http'
require 'json'

module Kubot
  class MyServer < SlackRubyBot::Server
    @support_channel = ENV['SLACK_SUPPORT_CHANNEL']
    @token = ENV['SLACK_API_TOKEN']

    def self.get_threaded_messages(data)
      rc = HTTP.post("https://slack.com/api/conversations.replies", params: {token: @token, channel:@support_channel,ts: data.thread_ts})
      return rc
    end

    on 'message' do |client, data|
      if data.channel == @support_channel && data.thread_ts != data.ts  
            rc = get_threaded_messages(data)
            original_channel = JSON.parse(rc.body)['messages'][0]['text'].split("|").first
            text = JSON.parse(rc.body)['messages'][-1]['text']
            client.say(
              text: text,
              channel: original_channel,
              as_user: true,
            )
      end
    end
  end
end
