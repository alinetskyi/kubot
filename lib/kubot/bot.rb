module Kubot
  class Bot < SlackRubyBot::Bot
     match(/^(?<bot>\S*)[\s]*(?<expression>.*)$/)

      def self.call(client, data, _match)
        client.say(channel: data.channel, text: "Hold on <@#{data.user}> I need to ask on of the specialists! ")
      end
  end
end

