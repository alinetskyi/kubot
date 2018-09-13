module Kubot 
  class Ask < SlackRubyBot::Commands::Base
    help do
        title 'ask'
        desc 'By typing ask you can ask our support team some questions'
    end
    
    command 'ask' do |match,client,data|
      MyServer.ask_question(client) 
    end 
  end
end

