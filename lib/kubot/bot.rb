module Kubot
  class Bot < SlackRubyBot::Bot
    #When bot's name is mentioned or he's DM messaged this method gets triggered
    #The regex below means that it's bot's name and something else
    match (/^(?<bot>\S*)[\s]*(?<expression>.*)$/) do |client, data, match|
      if data.text != 'help'
        KubotServer.ask_question(data)
      end
    end
  # TODO: Implement help command
  end
end
