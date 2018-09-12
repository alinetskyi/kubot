module Kubot
  class Setup
    def self.run 
      $db = KubotDB.new "kubot.db" 
      $db.create_channels_table
      $db.create_teams_table
      bot_tokens = $db.get_all_bot_tokens
      if bot_tokens != nil
        bot_tokens.each do |bot_token|
          MyServer.new(token: bot_token).start_async
        end 
      end 
    end
  end
end


