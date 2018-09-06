require 'http'
require 'json'

module Kubot
  class MyServer < SlackRubyBot::Server
    on 'message' do |client, data|
      case data.channel
      when "CCKSU9WQ4"
        if data.thread_ts != data.event_ts
          rc = HTTP.post("https://slack.com/api/conversations.replies", params: {token: ENV['SLACK_API_TOKEN'], channel:'CCKSU9WQ4',ts: data.thread_ts})
          chan = JSON.parse(rc.body)['messages'][0]['text'].split("|").first
          text = JSON.parse(rc.body)['messages'][-1]['text']
          client.say(
            text: text,
            channel: chan,
            as_user: true,
          )
        end
        if data.message.text?
          str = String.new
          str = data.message.text
          str = str.split("|").first
          client.say(
            text: str,
            channel: str)
        end
      else
        @keywords = ["peatio","barong","workbench","applogic","trading-ui","docker"] 
        @keywords.each do |keyword|
          if data.text.include? keyword    
            client.say( 
              text: "#{data.channel}| <@#{data.user}> : #{data.text}",
              channel: 'CCKSU9WQ4')
          end
        end
      end
    end
  end
end
