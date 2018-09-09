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
=begin
  get '/' do
  if params.key?('code')
   rc = JSON.parse(HTTP.post('https://slack.com/api/oauth.access', params: {
    client_id: ENV['SLACK_CLIENT_ID'],
    client_secret: ENV['SLACK_CLIENT_SECRET'],
    code: params['code']
   }))

   token = rc['bot']['bot_access_token']
   $teams[rc['team_id']] = token
   $team_names[rc['team_id']] = rc['team_name']
   team_id = rc['team_id']
   SlackRubyBot::Server.new(token: token).start_async

   "Team Successfully Registered token #{token}, team: #{team_id} #{rc}"
  else
   "Hello World"
  end
  end
=end
  end
end
