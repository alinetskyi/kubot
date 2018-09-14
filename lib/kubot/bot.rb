module Kubot 
  class Ask < SlackRubyBot::Commands::Base
    help do
        title 'ask'
        desc 'By typing ask you can ask our support team some questions'
    end

    command 'ask' do |match,client,data|
      if client.team != SLACK_SUPPORT_TEAM
        MyServer.ask_question(client)
      end
    end 
    
    help do
      title 'ans'
      desc "If you're from support you should type ans and then start answering the question"
    end

    command 'ans' do |match, client, data| 
      if client.team == SLACK_SUPPORT_TEAM
        MyServer.answer_question(client)
      end
    end

  end
end

