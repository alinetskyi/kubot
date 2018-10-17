module Kubot
  class Ask < SlackRubyBot::Commands::Base
    help do
      title "help"
      desc "just type whatever you want to get help with and our support team will answer you"
    end
    #When bot's name is mentioned or he's DM messaged this method gets triggered
    #The regex below means that it's bot's name and something else
    match (/^(?<bot>\S*)[\s]*(?<expression>.*)$/) do |client, data, match|
      KubotServer.ask_question(data)
    end
  end
end
