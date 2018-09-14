module Kubot
  class Setup
    @@db = KubotDB.new "kubot.db"
    def self.run 
      @@db.create_channels_table
      @@db.create_teams_table
      begin
        bots = @@db.get_all_bot_tokens
        puts bots
        bots.each do |bot|
          MyServer.new(token: bot[0].to_s).start_async
        end
      rescue
        return nil
      end
    end

    class << self
      def db
        @@db
      end
    end

  end
end


