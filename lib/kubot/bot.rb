module Kubot 
  class Ask < SlackRubyBot::Commands::Base
    help do
        title 'help'
        desc 'just type whatever you want to get help with and our support team will answer you'
    end

    match (/^(?<bot>\S*)[\s]*(?<expression>.*)$/) do |client,data,match|
          MyServer.ask_question(data)
    end
  end
end

